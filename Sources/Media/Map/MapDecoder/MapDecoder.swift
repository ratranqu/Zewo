import Core

extension Decodable {
    public init<Map : DecodingMap>(
        from map: Map,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) throws {
        let decoder = MapDecoder<Map>(referencing: map, userInfo: userInfo)
        try self.init(from: decoder)
    }
}

class MapDecoder<Map : DecodingMap> : Decoder {
    var stack: MapStack<DecodingMap>
    var codingPath: [CodingKey?]
    var userInfo: [CodingUserInfoKey: Any]
    
    init(
        referencing map: DecodingMap,
        at codingPath: [CodingKey?] = [],
        userInfo: [CodingUserInfoKey: Any]
    ) {
        self.stack = MapStack()
        self.stack.push(map)
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    func with<T>(pushedKey: CodingKey?, _ work: () throws -> T) rethrows -> T {
        codingPath.append(pushedKey)
        let result: T = try work()
        codingPath.removeLast()
        return result
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        let container = MapKeyedDecodingContainer<Key, Map>(
            referencing: self,
            wrapping: try stack.top.keyedContainer()
        )
        
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return MapUnkeyedDecodingContainer<Map>(
            referencing: self,
            wrapping: try stack.top.unkeyedContainer()
        )
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return MapSingleValueDecodingContainer<Map>(
            referencing: self,
            wrapping: try stack.top.singleValueContainer()
        )
    }
}
