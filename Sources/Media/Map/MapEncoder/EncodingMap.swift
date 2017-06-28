public protocol EncodingMap {
    func topLevel() throws -> EncodingMap
    
    static func makeKeyedContainer() throws -> EncodingMap
    static func makeUnkeyedContainer() throws -> EncodingMap
    
    mutating func encode(_ value: EncodingMap, forKey key: CodingKey) throws
    mutating func encode(_ value: EncodingMap) throws
    
    static func encodeNil() throws -> EncodingMap
    static func encode(_ value: Bool) throws -> EncodingMap
    static func encode(_ value: Int) throws -> EncodingMap
    static func encode(_ value: Int8) throws -> EncodingMap
    static func encode(_ value: Int16) throws -> EncodingMap
    static func encode(_ value: Int32) throws -> EncodingMap
    static func encode(_ value: Int64) throws -> EncodingMap
    static func encode(_ value: UInt) throws -> EncodingMap
    static func encode(_ value: UInt8) throws -> EncodingMap
    static func encode(_ value: UInt16) throws -> EncodingMap
    static func encode(_ value: UInt32) throws -> EncodingMap
    static func encode(_ value: UInt64) throws -> EncodingMap
    static func encode(_ value: Float) throws -> EncodingMap
    static func encode(_ value: Double) throws -> EncodingMap
    static func encode(_ value: String) throws -> EncodingMap
    
    // Optional
    
    static func makeKeyedContainer(forKey key: CodingKey) throws -> EncodingMap
    static func makeUnkeyedContainer(forKey key: CodingKey) throws -> EncodingMap
    
    mutating func encode(_ value: Bool, forKey key: CodingKey) throws
    mutating func encode(_ value: Int, forKey key: CodingKey) throws
    mutating func encode(_ value: Int8, forKey key: CodingKey) throws
    mutating func encode(_ value: Int16, forKey key: CodingKey) throws
    mutating func encode(_ value: Int32, forKey key: CodingKey) throws
    mutating func encode(_ value: Int64, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt8, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt16, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt32, forKey key: CodingKey) throws
    mutating func encode(_ value: UInt64, forKey key: CodingKey) throws
    mutating func encode(_ value: Float, forKey key: CodingKey) throws
    mutating func encode(_ value: Double, forKey key: CodingKey) throws
    mutating func encode(_ value: String, forKey key: CodingKey) throws
    
    mutating func encode(_ value: Bool) throws
    mutating func encode(_ value: Int) throws
    mutating func encode(_ value: Int8) throws
    mutating func encode(_ value: Int16) throws
    mutating func encode(_ value: Int32) throws
    mutating func encode(_ value: Int64) throws
    mutating func encode(_ value: UInt) throws
    mutating func encode(_ value: UInt8) throws
    mutating func encode(_ value: UInt16) throws
    mutating func encode(_ value: UInt32) throws
    mutating func encode(_ value: UInt64) throws
    mutating func encode(_ value: Float) throws
    mutating func encode(_ value: Double) throws
    mutating func encode(_ value: String) throws
}

extension EncodingMap {
    public static func makeKeyedContainer(forKey key: CodingKey) throws -> EncodingMap {
        return try makeKeyedContainer()
    }
    
    public static func makeUnkeyedContainer(forKey key: CodingKey) throws -> EncodingMap {
        return try makeKeyedContainer()
    }
    
    public mutating func encode(_ value: Bool, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int8, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int16, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int32, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Int64, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: UInt, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: UInt8, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: UInt16, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: UInt32, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: UInt64, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Float, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Double, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: String, forKey key: CodingKey) throws {
        try encode(Self.encode(value), forKey: key)
    }
    
    public mutating func encode(_ value: Bool) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: Int) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: Int8) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: Int16) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: Int32) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: Int64) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: UInt) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: UInt8) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: UInt16) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: UInt32) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: UInt64) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: Float) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: Double) throws {
        try encode(Self.encode(value))
    }
    
    public mutating func encode(_ value: String) throws {
        try encode(Self.encode(value))
    }
}
