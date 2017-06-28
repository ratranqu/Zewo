//import Mapper
//
//extension JSON : Map {
//    public func contains(_ key: CodingKey) -> Bool {
//        fatalError()
//    }
//    
//    public func keyedContainer(forKey: CodingKey) throws -> Map {
//        fatalError()
//    }
//    
//    public func unkeyedContainer(forKey: CodingKey) throws -> [Map] {
//        fatalError()
//    }
//    
//    public func singleValueContainer() throws -> Map {
//        fatalError()
//    }
//    
//    public func keyedContainer() throws -> Map {
//        fatalError()
//    }
//    
//    public func unkeyedContainer() throws -> [Map] {
//        fatalError()
//    }
//    
//    public static func makeKeyedContainer() throws -> Map {
//        fatalError()
//    }
//    
//    public static func makeUnkeyedContainer() throws -> Map {
//        fatalError()
//    }
//    
//    public func contains<Key>(_ key: Key) -> Bool where Key : CodingKey {
//        fatalError()
//    }
//    
//    public func allKeys<Key>(keyedBy: Key.Type) -> [Key] where Key : CodingKey {
//        return []
//    }
//    
//    public mutating func set(_ value: Map, forKeys keys: [CodingKey]) throws {
//        
//    }
//    
//    public mutating func append(_ value: Map) throws {
//        
//    }
//    
//    public init(array: [Map]) throws {
//        fatalError()
//    }
//    
//    public init(null: Void) throws {
//        self = .null
//    }
//    
//    public init(bool: Bool) throws {
//        self = .bool(bool)
//    }
//    
//    public init(int: Int) throws {
//        self = .int(int)
//    }
//    
//    public init(int8: Int8) throws {
//        guard let int = Int(exactly: int8) else {
//            throw EncodingError.invalidValue(int8, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(int16: Int16) throws {
//        guard let int = Int(exactly: int16) else {
//            throw EncodingError.invalidValue(int16, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(int32: Int32) throws {
//        guard let int = Int(exactly: int32) else {
//            throw EncodingError.invalidValue(int32, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(int64: Int64) throws {
//        guard let int = Int(exactly: int64) else {
//            throw EncodingError.invalidValue(int64, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(uint: UInt) throws {
//        guard let int = Int(exactly: uint) else {
//            throw EncodingError.invalidValue(uint, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(uint8: UInt8) throws {
//        guard let int = Int(exactly: uint8) else {
//            throw EncodingError.invalidValue(uint8, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(uint16: UInt16) throws {
//        guard let int = Int(exactly: uint16) else {
//            throw EncodingError.invalidValue(uint16, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(uint32: UInt32) throws {
//        guard let int = Int(exactly: uint32) else {
//            throw EncodingError.invalidValue(uint32, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(uint64: UInt64) throws {
//        guard let int = Int(exactly: uint64) else {
//            throw EncodingError.invalidValue(uint64, EncodingError.Context())
//        }
//        
//        self = .int(int)
//    }
//    
//    public init(float: Float) throws {
//        guard let double = Double(exactly: float) else {
//            throw EncodingError.invalidValue(float, EncodingError.Context())
//        }
//        
//        self = .double(double)
//    }
//    
//    public init(double: Double) throws {
//        self = .double(double)
//    }
//    
//    public init(string: String) throws {
//        self = .string(string)
//    }
//    
//    public static func keyedContainer() throws -> Map {
//        return JSON.object([:])
//    }
//    
//    public static func unkeyedContainer() throws -> Map {
//        return JSON.array([])
//    }
//    
//    public var isNull: Bool {
//        if case .null = self {
//            return true
//        }
//        
//        return false
//    }
//    
//    public var keys: [String] {
//        guard case let .object(object) = self else {
//            return []
//        }
//        
//        return [String](object.keys)
//    }
//    
//    public func value(forKey key: CodingKey) throws -> Map {
//        if let index = key.intValue {
//            guard case let .array(array) = self else {
//                throw DecodingError.typeMismatch(
//                    [JSON].self,
//                    DecodingError.Context(codingPath: [key])
//                )
//            }
//            
//            guard array.indices.contains(index) else {
//                throw DecodingError.valueNotFound(
//                    JSON.self,
//                    DecodingError.Context(codingPath: [key])
//                )
//            }
//            
//            return array[index]
//        } else {
//            guard case let .object(object) = self else {
//                throw DecodingError.typeMismatch(
//                    [String: JSON].self,
//                    DecodingError.Context(codingPath: [key])
//                )
//            }
//            
//            guard let newValue = object[key.stringValue] else {
//                throw DecodingError.valueNotFound(
//                    JSON.self,
//                    DecodingError.Context(codingPath: [key])
//                )
//            }
//            
//            return newValue
//        }
//    }
//    
//    public func arrayValue() throws -> [Map] {
//        if case .null = self {
//            throw DecodingError.valueNotFound(
//                [JSON].self,
//                DecodingError.Context()
//            )
//        }
//        
//        guard case let .array(array) = self else {
//            throw DecodingError.typeMismatch(
//                [JSON].self,
//                DecodingError.Context()
//            )
//        }
//        
//        return array
//    }
//    
//    public func boolValue() throws -> Bool {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Bool.self,
//                DecodingError.Context()
//            )
//        }
//        
//        guard case let .bool(bool) = value else {
//            throw DecodingError.typeMismatch(
//                Bool.self,
//                DecodingError.Context()
//            )
//        }
//        
//        return bool
//    }
//    
//    public func intValue() throws -> Int {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Int.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value {
//            return int
//        }
//        
//        if case let .double(double) = value, let int = Int(exactly: double) {
//            return int
//        }
//        
//        throw DecodingError.typeMismatch(
//            Int.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func int8Value() throws -> Int8 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Int8.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let int8 = Int8(exactly: int) {
//            return int8
//        }
//        
//        if case let .double(double) = value, let int8 = Int8(exactly: double) {
//            return int8
//        }
//        
//        throw DecodingError.typeMismatch(
//            Int8.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func int16Value() throws -> Int16 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Int16.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let int16 = Int16(exactly: int) {
//            return int16
//        }
//        
//        if case let .double(double) = value, let int16 = Int16(exactly: double) {
//            return int16
//        }
//        
//        throw DecodingError.typeMismatch(
//            Int16.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func int32Value() throws -> Int32 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Int32.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let int32 = Int32(exactly: int) {
//            return int32
//        }
//        
//        if case let .double(double) = value, let int32 = Int32(exactly: double) {
//            return int32
//        }
//        
//        throw DecodingError.typeMismatch(
//            Int32.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func int64Value() throws -> Int64 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Int64.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let int64 = Int64(exactly: int) {
//            return int64
//        }
//        
//        if case let .double(double) = value, let int64 = Int64(exactly: double) {
//            return int64
//        }
//        
//        throw DecodingError.typeMismatch(
//            Int64.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func uintValue() throws -> UInt {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                UInt.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let uint = UInt(exactly: int) {
//            return uint
//        }
//        
//        if case let .double(double) = value, let uint = UInt(exactly: double) {
//            return uint
//        }
//        
//        throw DecodingError.typeMismatch(
//            UInt.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func uint8Value() throws -> UInt8 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                UInt8.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let uint8 = UInt8(exactly: int) {
//            return uint8
//        }
//        
//        if case let .double(double) = value, let uint8 = UInt8(exactly: double) {
//            return uint8
//        }
//        
//        throw DecodingError.typeMismatch(
//            UInt8.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func uint16Value() throws -> UInt16 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                UInt16.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let uint16 = UInt16(exactly: int) {
//            return uint16
//        }
//        
//        if case let .double(double) = value, let uint16 = UInt16(exactly: double) {
//            return uint16
//        }
//        
//        throw DecodingError.typeMismatch(
//            UInt16.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func uint32Value() throws -> UInt32 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                UInt32.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let uint32 = UInt32(exactly: int) {
//            return uint32
//        }
//        
//        if case let .double(double) = value, let uint32 = UInt32(exactly: double) {
//            return uint32
//        }
//        
//        throw DecodingError.typeMismatch(
//            UInt32.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func uint64Value() throws -> UInt64 {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                UInt64.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let uint64 = UInt64(exactly: int) {
//            return uint64
//        }
//        
//        if case let .double(double) = value, let uint64 = UInt64(exactly: double) {
//            return uint64
//        }
//        
//        throw DecodingError.typeMismatch(
//            UInt64.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func floatValue() throws -> Float {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Float.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let float = Float(exactly: int) {
//            return float
//        }
//        
//        if case let .double(double) = value, let float = Float(exactly: double) {
//            return float
//        }
//        
//        throw DecodingError.typeMismatch(
//            Float.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func doubleValue() throws -> Double {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                Double.self,
//                DecodingError.Context()
//            )
//        }
//        
//        if case let .int(int) = value, let double = Double(exactly: int) {
//            return double
//        }
//        
//        if case let .double(double) = value {
//            return double
//        }
//        
//        throw DecodingError.typeMismatch(
//            Double.self,
//            DecodingError.Context()
//        )
//    }
//    
//    public func stringValue() throws -> String {
//        let value = self
//        
//        if case .null = value {
//            throw DecodingError.valueNotFound(
//                String.self,
//                DecodingError.Context()
//            )
//        }
//        
//        guard case let .string(string) = value else {
//            throw DecodingError.typeMismatch(
//                String.self,
//                DecodingError.Context()
//            )
//        }
//        
//        return string
//    }
//}
//
//
//
//

