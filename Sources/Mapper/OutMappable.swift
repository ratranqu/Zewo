/// Entity which can be mapped to any structured data type.
public protocol OutMappable {
    associatedtype Key : MappingKey
    
    /// Maps instance data to `mapper`.
    ///
    /// - parameter mapper: wraps the actual structured data instance.
    ///
    /// - throws: `OutMapperError`.
    func outMap<Destination>(mapper: inout OutMapper<Destination, Key>) throws
}

public protocol BasicOutMappable {
    func outMap<Destination>(mapper: inout BasicOutMapper<Destination>) throws
}

/// Entity which can be mapped to any structured data type in multiple ways using user-determined context instance.
public protocol OutMappableWithContext {
    associatedtype Key : MappingKey
    
    /// Context allows user to map data in different ways.
    associatedtype MappingContext
    
    
    /// Maps instance data to contextual `mapper`.
    ///
    /// - parameter mapper: wraps the actual structured data instance.
    ///
    /// - throws: `OutMapperError`
    func outMap<Destination >(mapper: inout ContextualOutMapper<Destination, Key, MappingContext>) throws
}

extension OutMappable {
    /// Maps `self` to `Destination` structured data instance.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    public func map<Destination : OutMap>(to destination: Destination = .blank) throws -> Destination {
        var mapper = OutMapper<Destination, Key>(of: destination)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
}

extension BasicOutMappable {
    /// Maps `self` to `Destination` structured data instance.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    public func map<Destination : OutMap>(to destination: Destination = .blank) throws -> Destination {
        var mapper = BasicOutMapper<Destination>(of: destination)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
}

extension OutMappableWithContext {
    /// Maps `self` to `Destination` structured data instance using `context`.
    ///
    /// - parameter destination: instance to map to. Leave it .blank if you want to create your instance from scratch.
    /// - parameter context:     use `context` to describe the way of mapping.
    ///
    /// - throws: `OutMapperError`.
    ///
    /// - returns: structured data instance created from `self`.
    public func map<Destination : OutMap>(to destination: Destination = .blank, context: MappingContext) throws -> Destination {
        var mapper = ContextualOutMapper<Destination, Key, MappingContext>(of: destination, context: context)
        try outMap(mapper: &mapper)
        return mapper.destination
    }
}
