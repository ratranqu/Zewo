/// An error that occurs during the mapping of a value.
public enum MappingError : Error {
    /// The context in which the error occurred.
    public struct Context {
        
        /// The path of `CodingKey`s taken to get to the point of the failing encode call.
        public let mappingPath: [MappingKey?]
        
        /// A description of what went wrong, for debugging purposes.
        public let debugDescription: String
        
        /// Initializes `self` with the given path of `CodingKey`s and a description of what went wrong.
        ///
        /// - parameter codingPath: The path of `CodingKey`s taken to get to the point of the failing encode call.
        /// - parameter debugDescription: A description of what went wrong, for debugging purposes.
        public init(mappingPath: [MappingKey?] = [], debugDescription: String = "") {
            self.mappingPath = mappingPath
            self.debugDescription = debugDescription
        }
    }
    
    /// `.invalidValue` indicates that an `Encoder` or its containers could not encode the given value.
    ///
    /// Contains the attempted value, along with context for debugging.
    case invalidValue(Any, MappingError.Context)
    
    /// `.typeMismatch` indicates that a value of the given type could not be decoded because it did not match the type of what was found in the encoded payload.
    ///
    /// Contains the attempted type, along with context for debugging.
    case typeMismatch(Any.Type, MappingError.Context)
    
    /// `.valueNotFound` indicates that a non-optional value of the given type was expected, but a null value was found.
    ///
    /// Contains the attempted type, along with context for debugging.
    case valueNotFound(Any.Type, MappingError.Context)
    
    /// `.keyNotFound` indicates that a `KeyedDecodingContainer` was asked for an entry for the given key, but did not contain one.
    ///
    /// Contains the attempted key, along with context for debugging.
    case keyNotFound(MappingKey, MappingError.Context)
    
    /// `.dataCorrupted` indicates that the data is corrupted or otherwise invalid.
    ///
    /// Contains context for debugging.
    case dataCorrupted(MappingError.Context)
}

public protocol Map {
    static func keyedContainer() throws -> Self
    static func unkeyedContainer() throws -> Self
    
    init(array: [Self]) throws
    
    init(null: Void) throws
    init(bool: Bool) throws
    init(int: Int) throws
    init(int8: Int8) throws
    init(int16: Int16) throws
    init(int32: Int32) throws
    init(int64: Int64) throws
    init(uint: UInt) throws
    init(uint8: UInt8) throws
    init(uint16: UInt16) throws
    init(uint32: UInt32) throws
    init(uint64: UInt64) throws
    init(float: Float) throws
    init(double: Double) throws
    init(string: String) throws
    
    mutating func set(_ value: Self, forKeys keys: [MappingKey]) throws
    mutating func append(_ value: Self) throws
    
    var keys: [String] { get }
    
    var isNull: Bool { get }
    
    func value(forKeys keys: [MappingKey]) throws -> Self?
    func arrayValue(forKeys keys: [MappingKey]) throws -> [Self]?
    
    func boolValue(forKeys keys: [MappingKey]) throws -> Bool?
    func intValue(forKeys keys: [MappingKey]) throws -> Int?
    func int8Value(forKeys keys: [MappingKey]) throws -> Int8?
    func int16Value(forKeys keys: [MappingKey]) throws -> Int16?
    func int32Value(forKeys keys: [MappingKey]) throws -> Int32?
    func int64Value(forKeys keys: [MappingKey]) throws -> Int64?
    func uintValue(forKeys keys: [MappingKey]) throws -> UInt?
    func uint8Value(forKeys keys: [MappingKey]) throws -> UInt8?
    func uint16Value(forKeys keys: [MappingKey]) throws -> UInt16?
    func uint32Value(forKeys keys: [MappingKey]) throws -> UInt32?
    func uint64Value(forKeys keys: [MappingKey]) throws -> UInt64?
    func floatValue(forKeys keys: [MappingKey]) throws -> Float?
    func doubleValue(forKeys keys: [MappingKey]) throws -> Double?
    func stringValue(forKeys keys: [MappingKey]) throws -> String?
}

extension Map {
    mutating func set(_ value: Self, forKeys keys: MappingKey...) throws {
        return try set(value, forKeys: keys)
    }
    
    public func value(forKeys keys: MappingKey...) throws -> Self? {
        return try value(forKeys: keys)
    }
    
    public func arrayValue(forKeys keys: MappingKey...) throws -> [Self]? {
        return try arrayValue(forKeys: keys)
    }
    
    public func boolValue(forKeys keys: MappingKey...) throws -> Bool? {
        return try boolValue(forKeys: keys)
    }
    
    public func intValue(forKeys keys: MappingKey...) throws -> Int? {
        return try intValue(forKeys: keys)
    }
    
    public func int8Value(forKeys keys: MappingKey...) throws -> Int8? {
        return try int8Value(forKeys: keys)
    }
    
    public func int16Value(forKeys keys: MappingKey...) throws -> Int16? {
        return try int16Value(forKeys: keys)
    }
    
    public func int32Value(forKeys keys: MappingKey...) throws -> Int32? {
        return try int32Value(forKeys: keys)
    }
    
    public func int64Value(forKeys keys: MappingKey...) throws -> Int64? {
        return try int64Value(forKeys: keys)
    }
    
    public func uintValue(forKeys keys: MappingKey...) throws -> UInt? {
        return try uintValue(forKeys: keys)
    }
    
    public func uint8Value(forKeys keys: MappingKey...) throws -> UInt8? {
        return try uint8Value(forKeys: keys)
    }
    
    public func uint16Value(forKeys keys: MappingKey...) throws -> UInt16? {
        return try uint16Value(forKeys: keys)
    }
    
    public func uint32Value(forKeys keys: MappingKey...) throws -> UInt32? {
        return try uint32Value(forKeys: keys)
    }
    
    public func uint64Value(forKeys keys: MappingKey...) throws -> UInt64? {
        return try uint64Value(forKeys: keys)
    }
    
    public func floatValue(forKeys keys: MappingKey...) throws -> Float? {
        return try floatValue(forKeys: keys)
    }
    
    public func doubleValue(forKeys keys: MappingKey...) throws -> Double? {
        return try doubleValue(forKeys: keys)
    }
    
    public func stringValue(forKeys keys: MappingKey...) throws -> String? {
        return try stringValue(forKeys: keys)
    }
}
