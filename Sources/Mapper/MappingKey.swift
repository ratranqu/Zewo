/// A type that can be used as a key for mapping.
public protocol MappingKey {
    /// The string to use in a named collection (e.g. a string-keyed dictionary).
    var keyValue: String { get }
    
    /// The int to use in an indexed collection (e.g. an int-keyed dictionary).
    var indexValue: Int? { get }
}

extension Int : MappingKey {
    public var keyValue: String {
        return self.description
    }
    
    public var indexValue: Int? {
        return self
    }
}

extension String : MappingKey {
    public var keyValue: String {
        return self
    }
    
    public var indexValue: Int? {
        return Int(self)
    }
}

extension MappingKey where Self : RawRepresentable, Self.RawValue : MappingKey {
    public var keyValue: String {
        return rawValue.keyValue
    }
    
    public var indexValue: Int? {
        return rawValue.indexValue
    }
}
