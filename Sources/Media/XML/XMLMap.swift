//import Mapper
//
//extension XMLElement : Map {
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
//    public init(array: [Map]) throws {
//        fatalError()
//    }
//
//    public func allKeys<Key>(keyedBy: Key.Type) -> [Key] where Key : CodingKey {
//        return []
//    }
//
//    public init(null: Void) throws {
//        fatalError()
//    }
//
//    public init(bool: Bool) throws {
//        fatalError()
//    }
//
//    public init(int: Int) throws {
//        fatalError()
//    }
//
//    public init(int8: Int8) throws {
//        fatalError()
//    }
//
//    public init(int16: Int16) throws {
//        fatalError()
//    }
//
//    public init(int32: Int32) throws {
//        fatalError()
//    }
//
//    public init(int64: Int64) throws {
//        fatalError()
//    }
//
//    public init(uint: UInt) throws {
//        fatalError()
//    }
//
//    public init(uint8: UInt8) throws {
//        fatalError()
//    }
//
//    public init(uint16: UInt16) throws {
//        fatalError()
//    }
//
//    public init(uint32: UInt32) throws {
//        fatalError()
//    }
//
//    public init(uint64: UInt64) throws {
//        fatalError()
//    }
//
//    public init(float: Float) throws {
//        fatalError()
//    }
//
//    public init(double: Double) throws {
//        fatalError()
//    }
//
//    public init(string: String) throws {
//        fatalError()
//    }
//
//    public func set(_ value: Map, forKeys keys: [CodingKey]) throws {
//        fatalError()
//    }
//
//    public func append(_ value: Map) throws {
//        fatalError()
//    }
//
//    public var keys: [String] {
//        fatalError()
//    }
//
//    public var isNull: Bool {
//        return false
//    }
//
//    public func value(forKey key: CodingKey) throws -> Map {
//        let elements = try arrayValue(forKey: key)
//
//        guard !elements.isEmpty else {
//            throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: [key]))
//        }
//
//        guard elements.count == 1, let element = elements.first else {
//            throw DecodingError.typeMismatch(XMLElement.self, DecodingError.Context(codingPath: [key]))
//        }
//
//        return element
//    }
//
//    public func arrayValue(forKey key: CodingKey) throws -> [Map] {
//        if let index = key.intValue {
//            guard elements.indices.contains(index) else {
//                throw DecodingError.keyNotFound(key, DecodingError.Context(codingPath: [key]))
//            }
//
//            return [elements[index]]
//        } else {
//            return getElements(named: key.stringValue)
//        }
//    }
//
//    public func arrayValue() throws -> [Map] {
//        return [self]
//    }
//
//    public func value(forKeys keys: CodingKey...) throws -> Map {
//        return try value(forKeys: keys)
//    }
//
//    public func value(forKeys keys: [CodingKey]) throws -> Map {
//        let elements = try arrayValue(forKeys: keys)
//
//        guard !elements.isEmpty else {
//            throw DecodingError.keyNotFound(keys.last ?? "", DecodingError.Context())
//        }
//
//        guard elements.count == 1, let element = elements.first else {
//            throw DecodingError.typeMismatch(XMLElement.self, DecodingError.Context(codingPath: keys))
//        }
//
//        return element
//    }
//
//    public func arrayValue(forKeys keys: CodingKey...) throws -> [Map] {
//        return try arrayValue(forKeys: keys)
//    }
//
//    public func arrayValue(forKeys keys: [CodingKey]) throws -> [Map] {
//        var value = [self]
//        var single = true
//        var codingPath: [CodingKey] = []
//
//        loop: for key in keys {
//            codingPath.append(key)
//
//            if let index = key.intValue {
//                if single, value.count == 1, let element = value.first {
//                    guard element.elements.indices.contains(index) else {
//                        throw DecodingError.keyNotFound(key, DecodingError.Context())
//                    }
//
//                    value = [element.elements[index]]
//                    single = true
//                    continue loop
//                }
//
//                guard value.indices.contains(index) else {
//                    throw DecodingError.keyNotFound(key, DecodingError.Context())
//                }
//
//                value = [value[index]]
//                single = true
//            } else {
//                let key = key.stringValue
//
//                guard value.count == 1, let element = value.first else {
//                    // More than one result
//                    throw DecodingError.typeMismatch([JSON].self, DecodingError.Context())
//                }
//
//                value = element.getElements(named: key)
//                single = false
//            }
//        }
//
//        return value
//    }
//
//    public func boolValue() throws -> Bool {

//    }
//
//    public func intValue() throws -> Int {

//    }
//
//    public func int8Value() throws -> Int8 {

//    }
//
//    public func int16Value() throws -> Int16 {

//    }
//
//    public func int32Value() throws -> Int32 {

//    }
//
//    public func int64Value() throws -> Int64 {

//    }
//
//    public func uintValue() throws -> UInt {

//    }
//
//    public func uint8Value() throws -> UInt8 {

//    }
//
//    public func uint16Value() throws -> UInt16 {

//    }
//
//    public func uint32Value() throws -> UInt32 {

//    }
//
//    public func uint64Value() throws -> UInt64 {

//    }
//
//    public func floatValue() throws -> Float {

//    }
//
//    public func doubleValue() throws -> Double {

//    }
//
//    public func stringValue() throws -> String {
//        
//    }
//
//    public static func keyedContainer() throws -> Map {
//        fatalError()
//    }
//
//    public static func unkeyedContainer() throws -> Map {
//        fatalError()
//    }
//}

