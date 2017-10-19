final class MediaUnkeyedEncodingContainer<Map : EncodingMedia> : UnkeyedEncodingContainer {

    var count: Int // TODO: properly update the property
    
    let encoder: MediaEncoder<Map>
    var codingPath: [CodingKey]
    
    init(referencing encoder: MediaEncoder<Map>, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.count = 0
    }
    
    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
        if let k = key {
            codingPath.append(k)
            defer { codingPath.removeLast() }
        }
        let result: T = try work()

        return result
    }
    
    func encodeNil() throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.push(Map.encodeNil())
        }
    }
    
    func encode(_ value: Bool) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: Int) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: Int8) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: Int16) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: Int32) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: Int64) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: UInt) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: UInt8) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: UInt16) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: UInt32) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: UInt64) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: Float)  throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: Double) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
    
    func encode(_ value: String) throws {
        try encoder.stack.withTop { map in
            try map.encode(value)
        }
    }
    
    func encode<T : Encodable>(_ value: T) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.stack.withTop { map in
                try map.encode(encoder.box(value))
            }
        }
    }
    
    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type
        ) -> KeyedEncodingContainer<NestedKey> {
        do {
            try encoder.stack.withTop { map in
                try map.encode(Map.makeKeyedContainer())
            }
        } catch {
            fatalError("return a failure container")
        }
        
        return with(pushedKey: nil) {
            let container = MediaKeyedEncodingContainer<Map, NestedKey>(
                referencing: encoder,
                codingPath: codingPath
            )
            
            return KeyedEncodingContainer(container)
        }
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        do {
            try encoder.stack.withTop { map in
                try map.encode(Map.makeUnkeyedContainer())
            }
        } catch {
            fatalError("return a failure container")
        }
        
        return with(pushedKey: nil) {
            return MediaUnkeyedEncodingContainer(
                referencing: encoder,
                codingPath: codingPath
            )
        }
    }
    
    func superEncoder() -> Encoder {
        return MediaReferencingEncoder(referencing: encoder, at: nil) { value in
            try self.encoder.stack.withTop { map in
                try map.encode(value)
            }
        }
    }
}
