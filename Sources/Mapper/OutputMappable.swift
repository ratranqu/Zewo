public protocol OutputMappable {
    associatedtype Key : MappingKey
    func map<Map>(mapper: inout Mapper<Map, Key>) throws
}

public protocol ContextOutputMappable {
    associatedtype Key : MappingKey
    associatedtype Context
    
    func outMap<Map >(mapper: inout ContextualMapper<Map, Key, Context>) throws
}

extension OutputMappable {
    public func map<Destination : Map>(to destination: Destination) throws -> Destination {
        var mapper = Mapper<Destination, Key>(of: destination)
        try map(mapper: &mapper)
        return mapper.map
    }
    
    public func map<Destination : Map>() throws -> Destination {
        let destination = try Destination.keyedContainer()
        return try map(to: destination)
    }
}

extension ContextOutputMappable {
    public func map<Destination : Map>(to destination: Destination, context: Context) throws -> Destination {
        var mapper = ContextualMapper<Destination, Key, Context>(of: destination, context: context)
        try outMap(mapper: &mapper)
        return mapper.map
    }
    
    public func map<Destination : Map>(context: Context) throws -> Destination {
        let destination = try Destination.keyedContainer()
        return try map(to: destination, context: context)
    }
}
