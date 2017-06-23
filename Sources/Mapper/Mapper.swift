public protocol MapperProtocol {
    associatedtype Key : MappingKey
    associatedtype Source : Map
    
    var map: Source { get set }
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
    case cannotSet(Error)
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
        return try map.boolValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int {
        return try map.intValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int8 {
        return try map.int8Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int16 {
        return try map.int16Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int32 {
        return try map.int32Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int64 {
        return try map.int64Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt {
        return try map.uintValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt8 {
        return try map.uint8Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt16 {
        return try map.uint16Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt32 {
        return try map.uint32Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt64 {
        return try map.uint64Value(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Float {
        return try map.floatValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Double {
        return try map.doubleValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> String {
        return try map.stringValue(forKeys: keys).unwrap(forKeys: keys)
    }
    
    public func map<T : InputMappable>(from keys: Key...) throws -> T {
        return try T(mapper: Mapper(of: map.value(forKeys: keys).unwrap(forKeys: keys)))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key..., context: T.Context) throws -> T {
        return try T(mapper: ContextualMapper(
            of: map.value(forKeys: keys).unwrap(forKeys: keys),
            context: context
        ))
    }
}

extension MapperProtocol {
    public func map(from keys: Key...) throws -> Bool? {
        return try map.boolValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int? {
        return try map.intValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int8? {
        return try map.int8Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int16? {
        return try map.int16Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int32? {
        return try map.int32Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Int64? {
        return try map.int64Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt? {
        return try map.uintValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt8? {
        return try map.uint8Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt16? {
        return try map.uint16Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt32? {
        return try map.uint32Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> UInt64? {
        return try map.uint64Value(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Float? {
        return try map.floatValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> Double? {
        return try map.doubleValue(forKeys: keys)
    }
    
    public func map(from keys: Key...) throws -> String? {
        return try map.stringValue(forKeys: keys)
    }
    
    public func map<T : InputMappable>(from keys: Key...) throws -> T? {
        guard let map = try map.value(forKeys: keys) else {
            return nil
        }
        
        return try T(mapper: Mapper(of: map))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key..., context: T.Context) throws -> T? {
        guard let map = try map.value(forKeys: keys) else {
            return nil
        }
        
        return try T(mapper: ContextualMapper(of: map, context: context))
    }
}

extension MapperProtocol {
    public func map(from keys: Key...) throws -> [Bool] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.boolValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.intValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int8] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int8Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int16] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int16Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int32] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int32Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Int64] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.int64Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uintValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt8] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint8Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt16] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint16Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt32] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint32Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [UInt64] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.uint64Value().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Float] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.floatValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [Double] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.doubleValue().unwrap()
        }
    }
    
    public func map(from keys: Key...) throws -> [String] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try $0.stringValue().unwrap()
        }
    }
    
    public func map<T : InputMappable>(from keys: Key...) throws -> [T] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try T(mapper: Mapper(of: $0))
        }
    }
    
    public func map<T : ContextInputMappable>(from keys: Key..., context: T.Context) throws -> [T] {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try T(mapper: ContextualMapper(of: $0, context: context))
        }
    }
}

extension MapperProtocol {
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Bool {
        return try value(rawValue: map.boolValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int {
        return try value(rawValue: map.intValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int8 {
        return try value(rawValue: map.int8Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int16 {
        return try value(rawValue: map.int16Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int32 {
        return try value(rawValue: map.int32Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Int64 {
        return try value(rawValue: map.int64Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt {
        return try value(rawValue: map.uintValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt8 {
        return try value(rawValue: map.uint8Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt16 {
        return try value(rawValue: map.uint16Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt32 {
        return try value(rawValue: map.uint32Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == UInt64 {
        return try value(rawValue: map.uint64Value(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Float {
        return try value(rawValue: map.floatValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == Double {
        return try value(rawValue: map.doubleValue(forKeys: keys).unwrap(forKeys: keys))
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T where T.RawValue == String {
        return try value(rawValue: map.stringValue(forKeys: keys).unwrap(forKeys: keys))
    }
}

extension MapperProtocol {
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Bool {
        return try map.boolValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int {
        return try map.intValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int8 {
        return try map.int8Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int16 {
        return try map.int16Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int32 {
        return try map.int32Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Int64 {
        return try map.int64Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt {
        return try map.uintValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt8 {
        return try map.uint8Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt16 {
        return try map.uint16Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt32 {
        return try map.uint32Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == UInt64 {
        return try map.uint64Value(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Float {
        return try map.floatValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == Double {
        return try map.doubleValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> T? where T.RawValue == String {
        return try map.stringValue(forKeys: keys).map({ try value(rawValue: $0) })
    }
}

extension MapperProtocol {
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Bool {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.boolValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.intValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int8 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int8Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int16 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int16Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int32 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int32Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Int64 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.int64Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uintValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt8 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint8Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt16 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint16Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt32 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint32Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == UInt64 {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.uint64Value().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Float {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.floatValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == Double {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.doubleValue().unwrap())
        }
    }
    
    public func map<T : RawRepresentable>(from keys: Key...) throws -> [T] where T.RawValue == String {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try value(rawValue: $0.stringValue().unwrap())
        }
    }
}

fileprivate extension MapperProtocol {
    func unwrap<T>(_ optional: T?) throws -> T {
        if let value = optional {
            return value
        } else {
            throw MapperError.wrongType(T.self)
        }
    }
    
    mutating func set(_ value: Source, forKeys keys: [Key]) throws {
        do {
            try map.set(value, forKeys: keys)
        } catch {
            throw MapperError.cannotSet(error)
        }
    }
}

extension MapperProtocol {
    public mutating func map(_ int: Int, to indexPath: Key...) throws {
        let map = try unwrap(Source(int: int))
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map(_ double: Double, to indexPath: Key...) throws {
        let map = try unwrap(Source(double: double))
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map(_ bool: Bool, to indexPath: Key...) throws {
        let map = try unwrap(Source(bool: bool))
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map(_ string: String, to indexPath: Key...) throws {
        let map = try unwrap(Source(string: string))
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map<T : OutputMappable>(_ value: T, to indexPath: Key...) throws {
        let new: Source = try value.map()
        try set(new, forKeys: indexPath)
    }
    
    //    public mutating func map<T : RawRepresentable>(_ value: T, to indexPath: Key...) throws {
    //        let map = try getMap(from: value.rawValue)
    //        try set(map, forKeys: indexPath)
    //    }
    
    public mutating func map<T : ContextOutputMappable>(_ value: T, to indexPath: Key..., context: T.Context) throws {
        let new = try value.map(context: context) as Source
        try set(new, forKeys: indexPath)
    }
    
    public mutating func map(_ array: [Int], to indexPath: Key...) throws {
        let maps = try array.map({ try unwrap(Source(int: $0)) })
        let map = try Source(array: maps)
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map(_ array: [Double], to indexPath: Key...) throws {
        let maps = try array.map({ try unwrap(Source(double: $0)) })
        let map = try Source(array: maps)
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map(_ array: [Bool], to indexPath: Key...) throws {
        let maps = try array.map({ try unwrap(Source(bool: $0)) })
        let map = try Source(array: maps)
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map(_ array: [String], to indexPath: Key...) throws {
        let maps = try array.map({ try unwrap(Source(string: $0)) })
        let map = try Source(array: maps)
        try set(map, forKeys: indexPath)
    }
    
    public mutating func map<T : OutputMappable>(_ array: [T], to indexPath: Key...) throws {
        let maps: [Source] = try array.map({ try $0.map() })
        let map = try Source(array: maps)
        try set(map, forKeys: indexPath)
    }
    
    //    public mutating func map<T : RawRepresentable>(_ array: [T], to indexPath: Key...) throws {
    //        let maps = try array.map({ try self.getMap(from: $0.rawValue) })
    //        let map = try arrayMap(of: maps)
    //        try set(map, forKeys: indexPath)
    //    }
    
    public mutating func map<T : ContextOutputMappable>(_ array: [T], to indexPath: Key..., context: T.Context) throws {
        let maps: [Source] = try array.map({ try $0.map(context: context) })
        let map = try Source(array: maps)
        try set(map, forKeys: indexPath)
    }
}

extension ContextualMapperProtocol {
    public func map<T : ContextInputMappable>(from keys: Key...) throws -> T where T.Context == Context {
        return try T(mapper: ContextualMapper<Source, T.Key, T.Context>(
            of: map.value(forKeys: keys).unwrap(forKeys: keys),
            context: context
        ))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key...) throws -> T? where T.Context == Context {
        guard let leveled = try map.value(forKeys: keys) else {
            return nil
        }
        
        return try T(mapper: ContextualMapper<Source, T.Key, T.Context>(of: leveled, context: context))
    }
    
    public func map<T : ContextInputMappable>(from keys: Key...) throws -> [T] where T.Context == Context {
        return try map.arrayValue(forKeys: keys).unwrap(forKeys: keys).map {
            try T(mapper: ContextualMapper<Source, T.Key, T.Context>(of: $0, context: context))
        }
    }
    
    public mutating func map<T : ContextOutputMappable>(_ value: T, to indexPath: Key...) throws where T.Context == Context {
        let new: Source = try value.map(context: self.context)
        try set(new, forKeys: indexPath)
    }
    
    public mutating func map<T : ContextOutputMappable>(_ array: [T], to indexPath: Key...) throws where T.Context == Context {
        let maps: [Source] = try array.map({ try $0.map(context: context) })
        let map = try Source(array: maps)
        try set(map, forKeys: indexPath)
    }
}

/// Object that maps structured data instances to strongly-typed instances.
public struct Mapper<S : Map, K : MappingKey> : MapperProtocol {
    public var map: S
    public typealias Key = K
    
    /// Creates mapper for given `source`.
    ///
    /// - parameter source: source of mapping.
    public init(of map: S) {
        self.map = map
    }
    
    public init() throws {
        self.map = try S.keyedContainer()
    }
}

/// Object that maps structured data instances to strongly-typed instances using type-specific context.
public struct ContextualMapper<S : Map, K : MappingKey, C> : ContextualMapperProtocol {
    public var map: S
    public typealias Key = K
    public let context: C
    
    
    public init(of map: S, context: C) {
        self.map = map
        self.context = context
    }
    
    public init(context: Context) throws {
        self.map = try S.keyedContainer()
        self.context = context
    }
}
