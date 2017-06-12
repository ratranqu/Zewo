import Venice
import Core

public protocol Coder {
    static var mediaType: MediaType { get }
    
    func encode<T : Encodable>(
        _ value: T,
        to writable: Writable,
        deadline: Deadline
    ) throws
    
    func decode<T : Decodable>(
        from readable: Readable,
        deadline: Deadline
    ) throws -> T
}

// TODO: Make error CustomStringConvertible and ResponseRepresentable
public enum ContentError : Error {
    case unsupportedMediaType
}

public protocol Content : Codable {
    static var coders: Coders { get }
}

public struct Coders {
    let coders: [Coder]
    
    public init(_ coders: Coder...) {
        self.coders = coders
    }
    
    public func coder(for mediaType: MediaType) throws -> Coder {
        for coder in coders where type(of: coder).mediaType.matches(other: mediaType) {
            return coder
        }
    
        throw ContentError.unsupportedMediaType
    }
}

extension Coders {
    public static var `default`: Coders {
        return Coders(JSONCoder())
    }
}
