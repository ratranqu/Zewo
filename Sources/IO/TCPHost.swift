import Core
import POSIX
import Venice

public enum TCPError : Error {
    case failedToCreateSocket
    case failedToConnectSocket
    case failedToBindSocket
    case failedToListen
    case failedToGetSocketAddress
    case invalidFileDescriptor
}

public final class TCPHost : Host {
    private let socket: FileDescriptor
    public let ip: IP

    public init(socket: Int32, ip: IP) {
        self.socket = FileDescriptor(socket)
        self.ip = ip
    }

    public convenience init(ip: IP, backlog: Int, reusePort: Bool) throws {
        var address = ip.address
        
        guard let rawSocket = try? POSIX.socket(family: address.family, type: .stream, protocol: 0) else {
            throw TCPError.failedToCreateSocket
        }
        
        let socket = FileDescriptor(rawSocket)
        try tune(socket: socket)

        if reusePort {
            try setReusePort(socket: rawSocket)
        }

        do {
            try POSIX.bind(socket: rawSocket, address: address)
        } catch {
            throw TCPError.failedToBindSocket
        }

        try POSIX.listen(socket: rawSocket, backlog: backlog)

        // If the user requested an ephemeral port, retrieve the port number assigned by the OS now.
        if address.port == 0 {
            do {
                address = try POSIX.getAddress(socket: rawSocket)
            } catch {
                try close(socket: socket)
                throw TCPError.failedToGetSocketAddress
            }
        }

        let ip = IP(address: address)
        self.init(socket: rawSocket, ip: ip)
    }

    public convenience init(
        host: String = "0.0.0.0",
        port: Int = 8080,
        backlog: Int = 128,
        reusePort: Bool = false,
        deadline: Deadline
    ) throws {
        let ip = try IP(address: host, port: port, deadline: deadline)
        try self.init(ip: ip, backlog: backlog, reusePort: reusePort)
    }

    public func accept(deadline: Deadline) throws -> DuplexStream {
        loop: while true {
            do {
                let (rawSocket, address) = try POSIX.accept(socket: socket.fileDescriptor)
                let acceptSocket = FileDescriptor(rawSocket)
                try tune(socket: acceptSocket)
                let ip = IP(address: address)
                return TCPStream(socket: acceptSocket, ip: ip)
            } catch {
                switch error {
                case SystemError.resourceTemporarilyUnavailable, SystemError.operationWouldBlock:
                    try socket.poll(event: .read, deadline: deadline)
                    continue loop
                default:
                    throw error
                }
            }
        }
    }
}

func close(socket: FileDescriptor) throws {
    socket.clean()
    try POSIX.close(fileDescriptor: socket.fileDescriptor)
}

func tune(socket: FileDescriptor) throws {
    do {
        try setNonBlocking(fileDescriptor: socket.fileDescriptor)
        try setReuseAddress(socket: socket.fileDescriptor)
        #if os(macOS)
            try setNoSignalOnBrokenPipe(socket: socket.fileDescriptor)
        #endif
    } catch {
        try close(socket: socket)
        throw error
    }
}

func setReusePort(socket: FileDescriptor) throws {
    do {
        try POSIX.setReusePort(socket: socket.fileDescriptor)
    } catch {
        try close(socket: socket)
        throw error
    }
}