public protocol Map {
    func value(forKeys keys: [MappingKey]) throws -> Self?
    
//    static func box(_ value: Bool?) throws -> Self
//    static func box(_ value: Int?) throws -> Self
//    static func box(_ value: Int8?) throws -> Self
//    static func box(_ value: Int16?) throws -> Self
//    static func box(_ value: Int32?) throws -> Self
//    static func box(_ value: Int64?) throws -> Self
//    static func box(_ value: UInt?) throws -> Self
//    static func box(_ value: UInt8?) throws -> Self
//    static func box(_ value: UInt16?) throws -> Self
//    static func box(_ value: UInt32?) throws -> Self
//    static func box(_ value: UInt64?) throws -> Self
//    static func box(_ value: Float?) throws -> Self
//    static func box(_ value: Double?) throws -> Self
//    static func box(_ value: String?) throws -> Self
    
    func arrayValue(forKeys keys: [MappingKey]) throws -> [Map]?
    
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
    
    static func keyedContainer() throws -> Self
    static func unkeyedContainer() throws -> Self
}

extension Map {
    public func value(forKeys keys: MappingKey...) throws -> Self? {
        return try value(forKeys: keys)
    }
    
    public func arrayValue(forKeys keys: MappingKey...) throws -> [Map]? {
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
