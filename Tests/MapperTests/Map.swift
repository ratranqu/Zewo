import Mapper

public protocol MapInitializable {
    init(map: Foo) throws
}

public protocol MapRepresentable : MapFallibleRepresentable {
    var map: Foo { get }
}

public protocol MapFallibleRepresentable {
    func asFoo() throws -> Foo
}

extension MapRepresentable {
    public func asFoo() throws -> Foo {
        return map
    }
}

extension Foo : MapRepresentable {
    public var map: Foo {
        return self
    }
}

public protocol MapConvertible : MapInitializable, MapFallibleRepresentable {}

public enum Foo {
    case null
    case bool(Bool)
    case double(Double)
    case int(Int)
    case string(String)
    case array([Foo])
    case dictionary([String: Foo])
}

// MARK: MapError

public enum MapError : Error {
    case incompatibleType
    case outOfBounds
    case valueNotFound
    case notMapInitializable(Any.Type)
    case notMapRepresentable(Any.Type)
    case notMapDictionaryKeyInitializable(Any.Type)
    case notMapDictionaryKeyRepresentable(Any.Type)
    case cannotInitialize(type: Any.Type, from: Any.Type)
}

// MARK: Parser/Serializer Protocols

extension Bool : MapRepresentable {
    public var map: Foo {
        return .bool(self)
    }
}

extension Double : MapRepresentable {
    public var map: Foo {
        return .double(self)
    }
}

extension Int : MapRepresentable {
    public var map: Foo {
        return .int(self)
    }
}

extension String : MapRepresentable {
    public var map: Foo {
        return .string(self)
    }
}

extension Optional where Wrapped : MapRepresentable {
    public var map: Foo {
        switch self {
        case .some(let wrapped): return wrapped.map
        case .none: return .null
        }
    }
}

extension Array where Element : MapRepresentable {
    public var mapArray: [Foo] {
        return self.map({$0.map})
    }
    
    public var map: Foo {
        return .array(mapArray)
    }
}

public protocol MapDictionaryKeyRepresentable {
    var mapDictionaryKey: String { get }
}

extension String : MapDictionaryKeyRepresentable {
    public var mapDictionaryKey: String {
        return self
    }
}

extension Dictionary where Key : MapDictionaryKeyRepresentable, Value : MapRepresentable {
    public var mapDictionary: [String: Foo] {
        var dictionary: [String: Foo] = [:]
        
        for (key, value) in self.map({($0.0.mapDictionaryKey, $0.1.map)}) {
            dictionary[key] = value
        }
        
        return dictionary
    }
    
    public var map: Foo {
        return .dictionary(mapDictionary)
    }
}

// MARK: MapFallibleRepresentable

extension Optional : MapFallibleRepresentable {
    public func asFoo() throws -> Foo {
        guard Wrapped.self is MapFallibleRepresentable.Type else {
            throw MapError.notMapRepresentable(Wrapped.self)
        }
        if case .some(let wrapped as MapFallibleRepresentable) = self {
            return try wrapped.asFoo()
        }
        return .null
    }
}

extension Array : MapFallibleRepresentable {
    public func asFoo() throws -> Foo {
        guard Element.self is MapFallibleRepresentable.Type else {
            throw MapError.notMapRepresentable(Element.self)
        }
        var array: [Foo] = []
        array.reserveCapacity(count)
        for element in self {
            let element = element as! MapFallibleRepresentable
            array.append(try element.asFoo())
        }
        return .array(array)
    }
}

extension Dictionary : MapFallibleRepresentable {
    public func asFoo() throws -> Foo {
        guard Key.self is MapDictionaryKeyRepresentable.Type else {
            throw MapError.notMapDictionaryKeyRepresentable(Value.self)
        }
        guard Value.self is MapFallibleRepresentable.Type else {
            throw MapError.notMapRepresentable(Value.self)
        }
        var dictionary = [String: Foo](minimumCapacity: count)
        for (key, value) in self {
            let value = value as! MapFallibleRepresentable
            let key = key as! MapDictionaryKeyRepresentable
            dictionary[key.mapDictionaryKey] = try value.asFoo()
        }
        return .dictionary(dictionary)
    }
}

// MARK: Initializers

extension Foo {
    public init<T: MapRepresentable>(_ value: T?) {
        self = value?.map ?? .null
    }
    
    public init<T: MapRepresentable>(_ values: [T]?) {
        if let values = values {
            self = .array(values.map({$0.map}))
        } else {
            self = .null
        }
    }
    
    public init<T: MapRepresentable>(_ values: [T?]?) {
        if let values = values {
            self = .array(values.map({$0?.map ?? .null}))
        } else {
            self = .null
        }
    }
    
    public init<T: MapRepresentable>(_ values: [String: T]?) {
        if let values = values {
            var dictionary: [String: Foo] = [:]
            
            for (key, value) in values.map({($0.key, $0.value.map)}) {
                dictionary[key] = value
            }
            
            self = .dictionary(dictionary)
        } else {
            self = .null
        }
    }
    
    public init<T: MapRepresentable>(_ values: [String: T?]?) {
        if let values = values {
            var dictionary: [String: Foo] = [:]
            
            for (key, value) in values.map({($0.key, $0.value?.map ?? .null)}) {
                dictionary[key] = value
            }
            
            self = .dictionary(dictionary)
        } else {
            self = .null
        }
    }
}

// MARK: is<Type>

extension Foo {
    public var isNull: Bool {
        if case .null = self {
            return true
        }
        return false
    }
    
    public var isBool: Bool {
        if case .bool = self {
            return true
        }
        return false
    }
    
    public var isDouble: Bool {
        if case .double = self {
            return true
        }
        return false
    }
    
    public var isInt: Bool {
        if case .int = self {
            return true
        }
        return false
    }
    
    public var isString: Bool {
        if case .string = self {
            return true
        }
        return false
    }
    
    public var isArray: Bool {
        if case .array = self {
            return true
        }
        return false
    }
    
    public var isDictionary: Bool {
        if case .dictionary = self {
            return true
        }
        return false
    }
}

// MARK: as<type>?

extension Foo {
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    public var double: Double? {
        if case .double(let value) = self {
            return value
        }
        return nil
    }
    
    public var int: Int? {
        if case .int(let value) = self {
            return value
        }
        return nil
    }
    
    public var string: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    public var array: [Foo]? {
        return try? get()
    }
    
    public var dictionary: [String: Foo]? {
        return try? get()
    }
}

// MARK: try as<type>()

extension Foo {
    public func asBool(converting: Bool = false) throws -> Bool {
        guard converting else {
            return try get()
        }
        
        switch self {
        case .bool(let value):
            return value
            
        case .int(let value):
            return value != 0
            
        case .double(let value):
            return value != 0
            
        case .string(let value):
            switch value.lowercased() {
            case "true": return true
            case "false": return false
            default: throw MapError.incompatibleType
            }
            
        case .array(let value):
            return !value.isEmpty
            
        case .dictionary(let value):
            return !value.isEmpty
            
        case .null:
            return false
        }
    }
    
    public func asInt(converting: Bool = false) throws -> Int {
        guard converting else {
            return try get()
        }
        
        switch self {
        case .bool(let value):
            return value ? 1 : 0
            
        case .int(let value):
            return value
            
        case .double(let value):
            return Int(value)
            
        case .string(let value):
            if let int = Int(value) {
                return int
            }
            throw MapError.incompatibleType
            
        case .null:
            return 0
            
        default:
            throw MapError.incompatibleType
        }
    }
    
    public func asDouble(converting: Bool = false) throws -> Double {
        guard converting else {
            return try get()
        }
        
        switch self {
        case .bool(let value):
            return value ? 1.0 : 0.0
            
        case .int(let value):
            return Double(value)
            
        case .double(let value):
            return value
            
        case .string(let value):
            if let double = Double(value) {
                return double
            }
            throw MapError.incompatibleType
            
        case .null:
            return 0
            
        default:
            throw MapError.incompatibleType
        }
    }
    
    public func asString(converting: Bool = false) throws -> String {
        guard converting else {
            return try get()
        }
        
        switch self {
        case .bool(let value):
            return String(value)
            
        case .int(let value):
            return String(value)
            
        case .double(let value):
            return String(value)
            
        case .string(let value):
            return value
            
        case .array:
            throw MapError.incompatibleType
            
        case .dictionary:
            throw MapError.incompatibleType
            
        case .null:
            return "null"
        }
    }
    
    public func asArr(converting: Bool = false) throws -> [Foo] {
        guard converting else {
            return try get()
        }
        
        switch self {
        case .array(let value):
            return value
            
        case .null:
            return []
            
        default:
            throw MapError.incompatibleType
        }
    }
    
    public func asDictionary(converting: Bool = false) throws -> [String: Foo] {
        guard converting else {
            return try get()
        }
        
        switch self {
        case .dictionary(let value):
            return value
            
        case .null:
            return [:]
            
        default:
            throw MapError.incompatibleType
        }
    }
}

// MARK: Get

extension Foo {
    public func get<T : MapInitializable>(_ indexPath: MappingKey...) throws -> T {
        let map = try get(indexPath)
        return try T(map: map)
    }
    
    public func get<T>(_ indexPath: MappingKey...) throws -> T {
        if indexPath.isEmpty {
            switch self {
            case .bool(let value as T): return value
            case .int(let value as T): return value
            case .double(let value as T): return value
            case .string(let value as T): return value
            case .array(let value as T): return value
            case .dictionary(let value as T): return value
            default: throw MapError.incompatibleType
            }
        }
        
        return try get(indexPath).get()
    }
    
    public func get(_ indexPath: MappingKey...) throws -> Foo {
        return try get(indexPath)
    }
    
    public func get(_ indexPath: [MappingKey]) throws -> Foo {
        var value: Foo = self
        
        for element in indexPath {
            if let index = element.indexValue {
                let array = try value.asArr()
                if array.indices.contains(index) {
                    value = array[index]
                } else {
                    throw MapError.outOfBounds
                }
            }
            
            let key = element.keyValue
            
            let dictionary = try value.asDictionary()
            if let newValue = dictionary[key] {
                value = newValue
            } else {
                throw MapError.valueNotFound
            }
        }
        
        return value
    }
}

// MARK: Set

extension Foo {
    public mutating func set<T : MapRepresentable>(_ value: T, for indexPath: MappingKey...) throws {
        try set(value, for: indexPath)
    }
    
    public mutating func set<T : MapRepresentable>(_ value: T, for indexPath: [MappingKey]) throws {
        try set(value, for: indexPath, merging: true)
    }
    
    fileprivate mutating func set<T : MapRepresentable>(_ value: T, for indexPath: [MappingKey], merging: Bool) throws {
        var indexPath = indexPath
        
        guard let first = indexPath.first else {
            return self = value.map
        }
        
        indexPath.removeFirst()
        
        if indexPath.isEmpty {
            if let index = first.indexValue {
                if case .array(var array) = self {
                    if !array.indices.contains(index) {
                        throw MapError.outOfBounds
                    }
                    array[index] = value.map
                    self = .array(array)
                } else {
                    throw MapError.incompatibleType
                }
            }
            
            let key = first.keyValue
            
            if case .dictionary(var dictionary) = self {
                let newValue = value.map
                if let existingDictionary = dictionary[key]?.dictionary,
                    let newDictionary = newValue.dictionary,
                    merging {
                    var combinedDictionary: [String: Foo] = [:]
                    
                    for (key, value) in existingDictionary {
                        combinedDictionary[key] = value
                    }
                    
                    for (key, value) in newDictionary {
                        combinedDictionary[key] = value
                    }
                    
                    dictionary[key] = .dictionary(combinedDictionary)
                } else {
                    dictionary[key] = newValue
                }
                self = .dictionary(dictionary)
            } else {
                throw MapError.incompatibleType
            }
        } else {
            var next: Foo
            
            if let _ = first.indexValue {
                next = (try? self.get(first)) ?? .array([])
            } else {
                next = (try? self.get(first)) ?? .dictionary([:])
            }
            
            try next.set(value, for: indexPath)
            try self.set(next, for: [first])
        }
    }
}

// MARK: Remove

extension Foo {
    public mutating func remove(_ indexPath: MappingKey...) throws {
        try self.remove(indexPath)
    }
    
    public mutating func remove(_ indexPath: [MappingKey]) throws {
        var indexPath = indexPath
        
        guard let first = indexPath.first else {
            return self = .null
        }
        
        indexPath.removeFirst()
        
        if indexPath.isEmpty {
            guard case .dictionary(var dictionary) = self else {
                throw MapError.incompatibleType
            }
            
            dictionary[first.keyValue] = nil
            self = .dictionary(dictionary)
        } else {
            guard var next = try? self.get(first) else {
                throw MapError.valueNotFound
            }
            try next.remove(indexPath)
            try self.set(next, for: [first], merging: false)
        }
    }
}

// MARK: Subscripts

extension Foo {
    public subscript(indexPath: MappingKey...) -> Foo {
        get {
            return self[indexPath]
        }
        
        set(value) {
            self[indexPath] = value
        }
    }
    
    public subscript(indexPath: [MappingKey]) -> Foo {
        get {
            return (try? self.get(indexPath)) ?? nil
        }
        
        set(value) {
            do {
                try self.set(value, for: indexPath)
            } catch {
                fatalError(String(describing: error))
            }
        }
    }
}

// MARK: Equatable

extension Foo : Equatable {}

public func == (lhs: Foo, rhs: Foo) -> Bool {
    switch (lhs, rhs) {
    case (.null, .null): return true
    case let (.int(l), .int(r)) where l == r: return true
    case let (.bool(l), .bool(r)) where l == r: return true
    case let (.string(l), .string(r)) where l == r: return true
    case let (.double(l), .double(r)) where l == r: return true
    case let (.array(l), .array(r)) where l == r: return true
    case let (.dictionary(l), .dictionary(r)) where l == r: return true
    default: return false
    }
}

// MARK: Literal Convertibles

extension Foo : ExpressibleByNilLiteral {
    public init(nilLiteral value: Void) {
        self = .null
    }
}

extension Foo : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .bool(value)
    }
}

extension Foo : ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .int(value)
    }
}

extension Foo : ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self = .double(value)
    }
}

extension Foo : ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: String) {
        self = .string(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .string(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

extension Foo : ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Foo...) {
        self = .array(elements)
    }
}

extension Foo : ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Foo)...) {
        var dictionary = [String: Foo](minimumCapacity: elements.count)
        
        for (key, value) in elements {
            dictionary[key] = value
        }
        
        self = .dictionary(dictionary)
    }
}

extension Foo : Map {
    public static func keyedContainer() throws -> Foo {
        return [:]
    }
    
    public static func unkeyedContainer() throws -> Foo {
        return []
    }
    
    public func value(forKeys keys: [MappingKey]) throws -> Foo? {
        var value = self
        
        for key in keys {
            if let index = key.indexValue {
                let array = try value.asArr()
                
                guard array.indices.contains(index) else {
                    return nil
                }
                
                value = array[index]
                continue
            } else {
                let key = key.keyValue
                
                let dictionary = try value.asDictionary()
                
                guard let newValue = dictionary[key] else {
                    return nil
                }
                
                value = newValue
                continue
            }
        }
        
        return value
    }
    
    public func arrayValue(forKeys keys: [MappingKey]) throws -> [Map]? {
        return try value(forKeys: keys)?.asArr()
    }
    
    public func boolValue(forKeys keys: [MappingKey]) throws -> Bool? {
        return try value(forKeys: keys)?.get()
    }
    
    public func intValue(forKeys keys: [MappingKey]) throws -> Int? {
        return try value(forKeys: keys)?.get()
    }
    
    public func int8Value(forKeys keys: [MappingKey]) throws -> Int8? {
        return try value(forKeys: keys)?.get()
    }
    
    public func int16Value(forKeys keys: [MappingKey]) throws -> Int16? {
        return try value(forKeys: keys)?.get()
    }
    
    public func int32Value(forKeys keys: [MappingKey]) throws -> Int32? {
        return try value(forKeys: keys)?.get()
    }
    
    public func int64Value(forKeys keys: [MappingKey]) throws -> Int64? {
        return try value(forKeys: keys)?.get()
    }
    
    public func uintValue(forKeys keys: [MappingKey]) throws -> UInt? {
        return try value(forKeys: keys)?.get()
    }
    
    public func uint8Value(forKeys keys: [MappingKey]) throws -> UInt8? {
        return try value(forKeys: keys)?.get()
    }
    
    public func uint16Value(forKeys keys: [MappingKey]) throws -> UInt16? {
        return try value(forKeys: keys)?.get()
    }
    
    public func uint32Value(forKeys keys: [MappingKey]) throws -> UInt32? {
        return try value(forKeys: keys)?.get()
    }
    
    public func uint64Value(forKeys keys: [MappingKey]) throws -> UInt64? {
        return try value(forKeys: keys)?.get()
    }
    
    public func floatValue(forKeys keys: [MappingKey]) throws -> Float? {
        return try value(forKeys: keys)?.get()
    }
    
    public func doubleValue(forKeys keys: [MappingKey]) throws -> Double? {
        return try value(forKeys: keys)?.get()
    }
    
    public func stringValue(forKeys keys: [MappingKey]) throws -> String? {
        return try value(forKeys: keys)?.get()
    }
}

extension Foo : OutMap {
    mutating public func set(_ map: Foo, at indexPath: MappingKey) throws {
        try self.set(map, for: [indexPath])
    }
    
    mutating public func set(_ map: Foo, at indexPath: [MappingKey]) throws {
        try self.set(map, for: indexPath)
    }
    
    public static var blank: Foo {
        return .dictionary([:])
    }
    
    public static func fromArray(_ array: [Foo]) -> Foo? {
        return .array(array)
    }
    
    public static func from<T>(_ value: T) -> Foo? {
        if let value = value as? MapRepresentable {
            return value.map
        }
        
        return nil
    }
}
