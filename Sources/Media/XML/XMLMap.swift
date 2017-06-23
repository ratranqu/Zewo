import Mapper

extension XMLElement : Map {
    public init(array: [XMLElement]) throws {
        fatalError()
    }
    
    public init(null: Void) throws {
        fatalError()
    }
    
    public init(bool: Bool) throws {
        fatalError()
    }
    
    public init(int: Int) throws {
        fatalError()
    }
    
    public init(int8: Int8) throws {
        fatalError()
    }
    
    public init(int16: Int16) throws {
        fatalError()
    }
    
    public init(int32: Int32) throws {
        fatalError()
    }
    
    public init(int64: Int64) throws {
        fatalError()
    }
    
    public init(uint: UInt) throws {
        fatalError()
    }
    
    public init(uint8: UInt8) throws {
        fatalError()
    }
    
    public init(uint16: UInt16) throws {
        fatalError()
    }
    
    public init(uint32: UInt32) throws {
        fatalError()
    }
    
    public init(uint64: UInt64) throws {
        fatalError()
    }
    
    public init(float: Float) throws {
        fatalError()
    }
    
    public init(double: Double) throws {
        fatalError()
    }
    
    public init(string: String) throws {
        fatalError()
    }
    
    public func set(_ value: XMLElement, forKeys keys: [MappingKey]) throws {
        fatalError()
    }
    
    public func append(_ value: XMLElement) throws {
        fatalError()
    }
    
    public var keys: [String] {
        fatalError()
    }
    
    public var isNull: Bool {
        return false
    }
    
    public func value(forKeys keys: [MappingKey]) throws -> XMLElement? {
        guard let elements = try arrayValue(forKeys: keys) else {
            return nil
        }
        
        guard !elements.isEmpty else {
            return nil
        }
        
        guard elements.count == 1, let element = elements.first else {
            throw MappingError.typeMismatch(XMLElement.self, MappingError.Context(mappingPath: keys))
        }
        
        return element
    }
    
    public func arrayValue(forKeys keys: [MappingKey]) throws -> [XMLElement]? {
        var value = [self]
        var single = true
        var mappingPath: [MappingKey] = []
        
        loop: for key in keys {
            mappingPath.append(key)
            
            if let index = key.indexValue {
                if single, value.count == 1, let element = value.first {
                    guard element.elements.indices.contains(index) else {
                        throw MappingError.keyNotFound(key, MappingError.Context())
                    }
                    
                    value = [element.elements[index]]
                    single = true
                    continue loop
                }
                
                guard value.indices.contains(index) else {
                    throw MappingError.keyNotFound(key, MappingError.Context())
                }
                
                value = [value[index]]
                single = true
            } else {
                let key = key.keyValue
                
                guard value.count == 1, let element = value.first else {
                    // More than one result
                    throw MappingError.typeMismatch([JSON].self, MappingError.Context())
                }
                
                value = element.getElements(named: key)
                single = false
            }
        }
        
        return value
    }
    
    public func boolValue(forKeys keys: [MappingKey]) throws -> Bool? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let bool = Bool(value.contents) else {
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
        
        guard let int = Int(value.contents) else {
            throw MappingError.typeMismatch(
                Int.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return int
    }
    
    public func int8Value(forKeys keys: [MappingKey]) throws -> Int8? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let int8 = Int8(value.contents) else {
            throw MappingError.typeMismatch(
                Int8.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return int8
    }
    
    public func int16Value(forKeys keys: [MappingKey]) throws -> Int16? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let int16 = Int16(value.contents) else {
            throw MappingError.typeMismatch(
                Int16.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return int16
    }
    
    public func int32Value(forKeys keys: [MappingKey]) throws -> Int32? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let int32 = Int32(value.contents) else {
            throw MappingError.typeMismatch(
                Int32.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return int32
    }
    
    public func int64Value(forKeys keys: [MappingKey]) throws -> Int64? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let int64 = Int64(value.contents) else {
            throw MappingError.typeMismatch(
                Int64.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return int64
    }
    
    public func uintValue(forKeys keys: [MappingKey]) throws -> UInt? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let uint = UInt(value.contents) else {
            throw MappingError.typeMismatch(
                UInt.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return uint
    }
    
    public func uint8Value(forKeys keys: [MappingKey]) throws -> UInt8? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let uint8 = UInt8(value.contents) else {
            throw MappingError.typeMismatch(
                UInt8.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return uint8
    }
    
    public func uint16Value(forKeys keys: [MappingKey]) throws -> UInt16? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let uint16 = UInt16(value.contents) else {
            throw MappingError.typeMismatch(
                UInt16.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return uint16
    }
    
    public func uint32Value(forKeys keys: [MappingKey]) throws -> UInt32? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let uint32 = UInt32(value.contents) else {
            throw MappingError.typeMismatch(
                UInt32.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return uint32
    }
    
    public func uint64Value(forKeys keys: [MappingKey]) throws -> UInt64? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let uint64 = UInt64(value.contents) else {
            throw MappingError.typeMismatch(
                UInt64.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return uint64
    }
    
    public func floatValue(forKeys keys: [MappingKey]) throws -> Float? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let float = Float(value.contents) else {
            throw MappingError.typeMismatch(
                Float.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return float
    }
    
    public func doubleValue(forKeys keys: [MappingKey]) throws -> Double? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        guard let double = Double(value.contents) else {
            throw MappingError.typeMismatch(
                Double.self,
                MappingError.Context(mappingPath: keys)
            )
        }
        
        return double
    }
    
    public func stringValue(forKeys keys: [MappingKey]) throws -> String? {
        guard let value = try value(forKeys: keys) else {
            return nil
        }
        
        return value.contents
    }
    
    public static func keyedContainer() throws -> XMLElement {
        fatalError()
    }
    
    public static func unkeyedContainer() throws -> XMLElement {
        fatalError()
    }
}
