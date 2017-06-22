/// Object that maps structured data instances to strongly-typed instances.
public protocol MapperProtocol {
    associatedtype Key : MappingKey
    
    /// Source of mapping (input).
    var source: Map { get }
}

public protocol ContextualMapperProtocol : MapperProtocol {
    associatedtype Context
    
    var context: Context { get }
}

public enum MapperError : Error {
    case valueNotFound(forKeys: [MappingKey])
    case wrongType(Any.Type)
    case cannotInitializeFromRawValue(Any)
    case cannotRepresentAsArray
    case userDefinedError
}

extension Optional {
    func unwrap(forKeys keys: [MappingKey] = []) throws -> Wrapped {
        guard let value = self else {
            throw MapperError.valueNotFound(forKeys: keys)
        }
        
        return value
    }
}

fileprivate extension MapperProtocol {
    func value<T : RawRepresentable>(rawValue: Bool) throws -> T where T.RawValue == Bool {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: Int) throws -> T where T.RawValue == Int {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: Int8) throws -> T where T.RawValue == Int8 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: Int16) throws -> T where T.RawValue == Int16 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: Int32) throws -> T where T.RawValue == Int32 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: Int64) throws -> T where T.RawValue == Int64 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: UInt) throws -> T where T.RawValue == UInt {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: UInt8) throws -> T where T.RawValue == UInt8 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: UInt16) throws -> T where T.RawValue == UInt16 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: UInt32) throws -> T where T.RawValue == UInt32 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: UInt64) throws -> T where T.RawValue == UInt64 {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: Float) throws -> T where T.RawValue == Float {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: Double) throws -> T where T.RawValue == Double {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
    
    func value<T : RawRepresentable>(rawValue: String) throws -> T where T.RawValue == String {
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.cannotInitializeFromRawValue(rawValue)
        }
        
        return value
    }
}

extension MapperProtocol {
    public func map(from keys: Key...) throws -> Bool {
        return try source.boolValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int {
        return try source.intValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int8 {
        return try source.int8Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int16 {
        return try source.int16Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int32 {
        return try source.int32Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int64 {
        return try source.int64Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt {
        return try source.uintValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt8 {
        return try source.uint8Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt16 {
        return try source.uint16Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt32 {
        return try source.uint32Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt64 {
        return try source.uint64Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Float {
        return try source.floatValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Double {
        return try source.doubleValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> String {
        return try source.stringValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map<T : InputMappable>(from keys: Key...) throws -> T {
        return try T(mapper: Mapper(of: source.value(forKeys: keys).unwrap(forKeys: keys)))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key..., context: T.Context) throws -> T {
        return try T(mapper: ContextualMapper(
            of: source.value(forKeys: keys).unwrap(forKeys: keys),
            context: context
        ))
    }
}

extension MapperProtocol {
    public func map(from keys: Key...) throws -> Bool? {
        return try source.boolValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int? {
        return try source.intValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int8? {
        return try source.int8Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int16? {
        return try source.int16Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int32? {
        return try source.int32Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int64? {
        return try source.int64Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt? {
        return try source.uintValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt8? {
        return try source.uint8Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt16? {
        return try source.uint16Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt32? {
        return try source.uint32Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt64? {
        return try source.uint64Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Float? {
        return try source.floatValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Double? {
        return try source.doubleValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> String? {
        return try source.stringValue(forKeys: keys)
    }
    
    public func map<T : InputMappable>(from keys: Key...) throws -> T? {
        guard let map = try source.value(forKeys: keys) else {
            return nil
        }
        
        return try T(mapper: Mapper(of: map))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key..., context: T.Context) throws -> T? {
        guard let map = try source.value(forKeys: keys) else {
            return nil
        }
        
        return try T(mapper: ContextualMapper(of: map, context: context))
    }
}

extension MapperProtocol {
    public func map(from keys: Key...) throws -> [Bool] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.boolValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.intValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int8] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int8Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int16] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int16Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int32] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int32Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int64] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int64Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uintValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt8] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint8Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt16] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint16Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt32] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint32Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt64] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint64Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Float] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.floatValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Double] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.doubleValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [String] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.stringValue().unwrap()
        }
    }
    
    public func map<T : InputMappable>(from keys: Key...) throws -> [T] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try T(mapper: Mapper(of: $0))
        }
    }
    
    public func map<T : ContextInputMappable>(from keys: Key..., context: T.Context) throws -> [T] {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try T(mapper: ContextualMapper(of: $0, context: context))
        }
    }
}

extension MapperProtocol {
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Bool {
        return try value(rawValue: source.boolValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int {
        return try value(rawValue: source.intValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int8 {
        return try value(rawValue: source.int8Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int16 {
        return try value(rawValue: source.int16Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int32 {
        return try value(rawValue: source.int32Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int64 {
        return try value(rawValue: source.int64Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt {
        return try value(rawValue: source.uintValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt8 {
        return try value(rawValue: source.uint8Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt16 {
        return try value(rawValue: source.uint16Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt32 {
        return try value(rawValue: source.uint32Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt64 {
        return try value(rawValue: source.uint64Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Float {
        return try value(rawValue: source.floatValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Double {
        return try value(rawValue: source.doubleValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == String {
        return try value(rawValue: source.stringValue(forKeys: keys).unwrap(forKeys: keys))
    }
}

extension MapperProtocol {
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Bool {
        return try source.boolValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int {
        return try source.intValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int8 {
        return try source.int8Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int16 {
        return try source.int16Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int32 {
        return try source.int32Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int64 {
        return try source.int64Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt {
        return try source.uintValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt8 {
        return try source.uint8Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt16 {
        return try source.uint16Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt32 {
        return try source.uint32Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt64 {
        return try source.uint64Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Float {
        return try source.floatValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Double {
        return try source.doubleValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == String {
        return try source.stringValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
}

extension MapperProtocol {
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Bool {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.boolValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.intValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int8 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int8Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int16 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int16Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int32 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int32Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int64 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int64Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uintValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt8 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint8Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt16 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint16Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt32 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint32Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt64 {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint64Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Float {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.floatValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Double {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.doubleValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == String {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.stringValue().unwrap())
        }
    }
}

extension ContextualMapperProtocol {
    public func map<T : ContextInputMappable>(from keys: Key...) throws -> T where T.Context == Context {
        return try T(mapper: ContextualMapper<T.Key, T.Context>(
            of: source.value(forKeys: keys).unwrap(forKeys: keys),
            context: context
        ))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key...) throws -> T? where T.Context == Context {
        guard let leveled = try source.value(forKeys: keys) else {
            return nil
        }
        
        return try T(mapper: ContextualMapper<T.Key, T.Context>(of: leveled, context: context))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key...) throws -> [T] where T.Context == Context {
        return try source.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try T(mapper: ContextualMapper<T.Key, T.Context>(of: $0, context: context))
        }
    }
}

/// Object that maps structured data instances to strongly-typed instances.
public struct Mapper<K : MappingKey> : MapperProtocol {
    public let source: Map
    public typealias Key = K
    
    /// Creates mapper for given `source`.
    ///
    /// - parameter source: source of mapping.
    public init(of source: Map) {
        self.source = source
    }
}

/// Object that maps structured data instances to strongly-typed instances using type-specific context.
public struct ContextualMapper<K : MappingKey, Context> : ContextualMapperProtocol {
    public let source: Map
    public typealias Key = K
    /// Context is used to determine the way of mapping, so it allows to map instance in several different ways.
    public let context: Context
    
    
    /// Creates mapper for given `source` and `context`.
    ///
    /// - parameter source:  source of mapping.
    /// - parameter context: context for mapping describal.
    public init(of source: Map, context: Context) {
        self.source = source
        self.context = context
    }
}
