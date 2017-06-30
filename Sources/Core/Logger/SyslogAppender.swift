#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
    
// Used to map syslog levels with Logger levels
extension Logger.Level: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
}

// Wrapper for syslog. 
func syslog(priority : Int32, _ message : String, _ args : CVarArg...) {
    withVaList(args) { vsyslog(priority, message.cString(using: String.Encoding.utf8), $0) }
}

/// Log appender for Syslog integration 
public final class SyslogAppender: LogAppender {
    static let levelMapping: [Logger.Level: Int32] = [
      Logger.Level.trace  : LOG_DEBUG,
      Logger.Level.debug  : LOG_DEBUG,
      Logger.Level.info   : LOG_INFO,
      Logger.Level.warning: LOG_WARNING,
      Logger.Level.error  : LOG_ERR,
      Logger.Level.fatal  : LOG_EMERG,
      Logger.Level.all    : LOG_INFO
    ]
    public let levels: Logger.Level

    /// Default initializer.
    ///
    /// - parameters:
    ///    - levels: What is the log level you want to use
    ///    - ident: Identification for syslog.
    ///
    /// - remarks:
    /// The ident string is important for syslog. Since the daemon writes data
    /// into the same file, _ident_ identifies your process logs in it. This
    /// parameter defaults to "Zewo" but it is a good idea to provide your own
    /// string in order to get it simple to check your logs on the server´s log
    /// data.
    public init(levels: Logger.Level = .all, ident: String = "Zewo") {
        self.levels = levels
        openlog(ident, LOG_CONS|LOG_NDELAY|LOG_PID, LOG_USER)
    }

    deinit {
        closelog()
    }
    
    public func append(event: Logger.Event) {
        var logMessage = event.locationInfo.description
        if let message = event.message {
            logMessage = "\(logMessage): \(String(describing: message))"
        }
        syslog(priority: SyslogAppender.levelMapping[event.level]!, logMessage)
    }
}
