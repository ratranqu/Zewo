/// Entity which can be mapped (initialized) from any structured data type.
public protocol InputMappable {
    associatedtype Key : MappingKey
    
    /// Creates instance from instance of `Source` packed into mapper with type-specific `MappingKeys`.
    init<Source>(mapper: Mapper<Source, Key>) throws
}

/// Entity which can be mapped (initialized) from any structured data type in multiple ways using user-determined context instance.
public protocol ContextInputMappable {
    associatedtype Context
    associatedtype Key : MappingKey
    
    /// Creates instance from instance of `Source` packed into contextual mapper with type-specific `MappingKeys`.
    init<Source>(mapper: ContextualMapper<Source, Key, Context>) throws
}

extension InputMappable {
    /// Creates instance from `source`.
    public init<Source : Map>(from source: Source) throws {
        let mapper = Mapper<Source, Key>(of: source)
        try self.init(mapper: mapper)
    }
}

extension ContextInputMappable {
    /// Creates instance from `source` using given context.
    public init<Source : Map>(from source: Source, context: Context) throws {
        let mapper = ContextualMapper<Source, Key, Context>(of: source, context: context)
        try self.init(mapper: mapper)
    }
}
