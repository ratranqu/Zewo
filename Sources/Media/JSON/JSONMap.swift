import Mapper

extension JSON : Map {
    public mutating func set(_ value: JSON, forKeys keys: [MappingKey]) throws {
        
    }
    
    public mutating func append(_ value: JSON) throws {
        
    }
    
    public init(array: [JSON]) throws {
        self = .array(array)
    }
    
    public init(null: Void) throws {
        self = .null
    }
    
    public init(bool: Bool) throws {
        self = .bool(bool)
    }
    
    public init(int: Int) throws {
        self = .int(int)
    }
    
    public init(int8: Int8) throws {
        guard let int = Int(exactly: int8) else {
            throw MappingError.invalidValue(int8, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(int16: Int16) throws {
        guard let int = Int(exactly: int16) else {
            throw MappingError.invalidValue(int16, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(int32: Int32) throws {
        guard let int = Int(exactly: int32) else {
            throw MappingError.invalidValue(int32, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(int64: Int64) throws {
        guard let int = Int(exactly: int64) else {
            throw MappingError.invalidValue(int64, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(uint: UInt) throws {
        guard let int = Int(exactly: uint) else {
            throw MappingError.invalidValue(uint, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(uint8: UInt8) throws {
        guard let int = Int(exactly: uint8) else {
            throw MappingError.invalidValue(uint8, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(uint16: UInt16) throws {
        guard let int = Int(exactly: uint16) else {
            throw MappingError.invalidValue(uint16, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(uint32: UInt32) throws {
        guard let int = Int(exactly: uint32) else {
            throw MappingError.invalidValue(uint32, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(uint64: UInt64) throws {
        guard let int = Int(exactly: uint64) else {
            throw MappingError.invalidValue(uint64, MappingError.Context())
        }
        
        self = .int(int)
    }
    
    public init(float: Float) throws {
        guard let double = Double(exactly: float) else {
            throw MappingError.invalidValue(float, MappingError.Context())
        }
        
        self = .double(double)
    }
    
    public init(double: Double) throws {
        self = .double(double)
    }
    
    public init(string: String) throws {
        self = .string(string)
    }
    
    public static func keyedContainer() throws -> JSON {
        return [:]
    }
    
    public static func unkeyedContainer() throws -> JSON {
        return []
    }
    
    public var isNull: Bool {
        if case .null = self {
            return true
        }
        
        return false
    }
    
    public var keys: [String] {
        guard case let .object(object) = self else {
            return []
        }
        
        return [String](object.keys)
    }
    
    public func value(forKeys keys: [MappingKey]) throws -> JSON? {
        var value = self
        var mappingPath: [MappingKey] = []
        
        for key in keys {
            mappingPath.append(key)
            
            if let index = key.indexValue {
                guard case let .array(array) = value else {
                    throw MappingError.typeMismatch(
                        [JSON].self,
                        MappingError.Context(mappingPath: mappingPath)
                    )
                }
                
                guard array.indices.contains(index) else {
                    return nil
                }
                
                value = array[index]
                continue
            } else {
                let key = key.keyValue
                
                guard case let .object(object) = value else {
                    throw MappingError.typeMismatch(
                        [String: JSON].self,
                        MappingError.Context(mappingPath: mappingPath)
                    )
                }
                
                guard let newValue = object[key] else {
                    return nil
                }
                
                value = newValue
                continue
            }
        }
        
        return value
    }
    
    public func arrayValue(forKeys keys: [MappingKey]) throws -> [JSON]? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        guard case let .array(array) = value else {
            throw MappingError.typeMismatch(
                [JSON].self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return array
    }
    
    public func boolValue(forKeys keys: [MappingKey]) throws -> Bool? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        guard case let .bool(bool) = value else {
            throw MappingError.typeMismatch(
                Bool.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return bool
    }
    
    public func intValue(forKeys keys: [MappingKey]) throws -> Int? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value {
            return int
        }
        
        if case let .double(double) = value, let int = Int(exactly: double) {
            return int
        }
        
        throw MappingError.typeMismatch(
            Int.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func int8Value(forKeys keys: [MappingKey]) throws -> Int8? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let int8 = Int8(exactly: int) {
            return int8
        }
        
        if case let .double(double) = value, let int8 = Int8(exactly: double) {
            return int8
        }
        
        throw MappingError.typeMismatch(
            Int8.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func int16Value(forKeys keys: [MappingKey]) throws -> Int16? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let int16 = Int16(exactly: int) {
            return int16
        }
        
        if case let .double(double) = value, let int16 = Int16(exactly: double) {
            return int16
        }
        
        throw MappingError.typeMismatch(
            Int16.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func int32Value(forKeys keys: [MappingKey]) throws -> Int32? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let int32 = Int32(exactly: int) {
            return int32
        }
        
        if case let .double(double) = value, let int32 = Int32(exactly: double) {
            return int32
        }
        
        throw MappingError.typeMismatch(
            Int32.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func int64Value(forKeys keys: [MappingKey]) throws -> Int64? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let int64 = Int64(exactly: int) {
            return int64
        }
        
        if case let .double(double) = value, let int64 = Int64(exactly: double) {
            return int64
        }
        
        throw MappingError.typeMismatch(
            Int64.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func uintValue(forKeys keys: [MappingKey]) throws -> UInt? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let uint = UInt(exactly: int) {
            return uint
        }
        
        if case let .double(double) = value, let uint = UInt(exactly: double) {
            return uint
        }
        
        throw MappingError.typeMismatch(
            UInt.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func uint8Value(forKeys keys: [MappingKey]) throws -> UInt8? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let uint8 = UInt8(exactly: int) {
            return uint8
        }
        
        if case let .double(double) = value, let uint8 = UInt8(exactly: double) {
            return uint8
        }
        
        throw MappingError.typeMismatch(
            UInt8.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func uint16Value(forKeys keys: [MappingKey]) throws -> UInt16? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let uint16 = UInt16(exactly: int) {
            return uint16
        }
        
        if case let .double(double) = value, let uint16 = UInt16(exactly: double) {
            return uint16
        }
        
        throw MappingError.typeMismatch(
            UInt16.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func uint32Value(forKeys keys: [MappingKey]) throws -> UInt32? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let uint32 = UInt32(exactly: int) {
            return uint32
        }
        
        if case let .double(double) = value, let uint32 = UInt32(exactly: double) {
            return uint32
        }
        
        throw MappingError.typeMismatch(
            UInt32.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func uint64Value(forKeys keys: [MappingKey]) throws -> UInt64? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let uint64 = UInt64(exactly: int) {
            return uint64
        }
        
        if case let .double(double) = value, let uint64 = UInt64(exactly: double) {
            return uint64
        }
        
        throw MappingError.typeMismatch(
            UInt64.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func floatValue(forKeys keys: [MappingKey]) throws -> Float? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let float = Float(exactly: int) {
            return float
        }
        
        if case let .double(double) = value, let float = Float(exactly: double) {
            return float
        }
        
        throw MappingError.typeMismatch(
            Float.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func doubleValue(forKeys keys: [MappingKey]) throws -> Double? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        if case let .int(int) = value, let double = Double(exactly: int) {
            return double
        }
        
        if case let .double(double) = value {
            return double
        }
        
        throw MappingError.typeMismatch(
            Double.self,
            MappingError.Context(mappingPath: keys)
        )
    }
    
    public func stringValue(forKeys keys: [MappingKey]) throws -> String? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        if case .null = value {
            return nil
        }
        
        guard case let .string(string) = value else {
            throw MappingError.typeMismatch(
                String.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return string
    }
}

