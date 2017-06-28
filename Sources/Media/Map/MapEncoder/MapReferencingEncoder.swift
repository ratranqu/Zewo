class MapReferencingEncoder<Map : EncodingMap> : MapEncoder<Map> {
    let encoder: MapEncoder<Map>
    let write: (EncodingMap) throws -> Void
    
    init(
        referencing encoder: MapEncoder<Map>,
        at key: CodingKey?,
        write: @escaping (EncodingMap) throws -> Void
        ) {
        self.encoder = encoder
        self.write = write
        super.init(codingPath: encoder.codingPath, userInfo: encoder.userInfo)
        self.codingPath.append(key)
    }
    
    override var canEncodeNewElement: Bool {
        // With a regular encoder, the storage and coding path grow together.
        // A referencing encoder, however, inherits its parents coding path, as well as the key it was created for.
        // We have to take this into account.
        return stack.count == codingPath.count - encoder.codingPath.count - 1
    }
    
    deinit {
        let value: EncodingMap
        
        switch stack.count {
        case 0: value = try! Map.makeKeyedContainer()
        case 1: value = stack.pop()
        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
        }
        
        do {
            try write(value)
        } catch {
            fatalError("Could not write to container.")
        }
    }
}
