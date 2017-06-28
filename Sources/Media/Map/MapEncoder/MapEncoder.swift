import Core

//extension Encodable {
//    public func encode<M : Map>(
//        to map: M.Type = M.self,
//        userInfo: [CodingUserInfoKey: Any] = [:]
//    ) throws -> M {
//        let encoder = MapEncoder<M>(userInfo: userInfo)
//        try encode(to: encoder)
//        return try encoder.map()
//    }
//}
//
//fileprivate class MapEncoder<M : Map> : Encoder {
//    var stack: MapStack<M>
//    var codingPath: [CodingKey?]
//    var userInfo: [CodingUserInfoKey: Any]
//
//    init(codingPath: [CodingKey?] = [], userInfo: [CodingUserInfoKey: Any]) {
//        self.stack = MapStack()
//        self.codingPath = codingPath
//        self.userInfo = userInfo
//    }
//
//    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
//        codingPath.append(key)
//        let result: T = try work()
//        codingPath.removeLast()
//        return result
//    }
//
//    var canEncodeNewElement: Bool {
//        // Every time a new value gets encoded, the key it's encoded for is pushed onto the coding path (even if it's a nil key from an unkeyed container).
//        // At the same time, every time a container is requested, a new value gets pushed onto the storage stack.
//        // If there are more values on the storage stack than on the coding path, it means the value is requesting more than one container, which violates the precondition.
//        //
//        // This means that anytime something that can request a new container goes onto the stack, we MUST push a key onto the coding path.
//        // Things which will not request containers do not need to have the coding path extended for them (but it doesn't matter if it is, because they will not reach here).
//        return stack.count == codingPath.count
//    }
//
//    func assertCanRequestNewContainer() {
//        guard canEncodeNewElement else {
//            preconditionFailure("Attempt to encode with new container when already encoded with a container.")
//        }
//    }
//
//    func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
//        assertCanRequestNewContainer()
//
//        do {
//            try stack.pushKeyedContainer()
//        } catch {
//            fatalError("return a failure container")
//        }
//
//        let container = MapKeyedEncodingContainer<M, Key>(
//            referencing: self,
//            codingPath: codingPath
//        )
//
//        return KeyedEncodingContainer(container)
//    }
//
//    func unkeyedContainer() -> UnkeyedEncodingContainer {
//        assertCanRequestNewContainer()
//
//        do {
//            try stack.pushUnkeyedContainer()
//        } catch {
//            fatalError("return a failure container")
//        }
//
//        return MapUnkeyedEncodingContainer(
//            referencing: self,
//            codingPath: codingPath
//        )
//    }
//
//    func singleValueContainer() -> SingleValueEncodingContainer {
//        assertCanRequestNewContainer()
//        return self
//    }
//
//    func map() throws -> M {
//        guard stack.count > 0 else {
//            let context = EncodingError.Context(
//                debugDescription: "encoder did not encode any values."
//            )
//
//            throw EncodingError.invalidValue(self, context)
//        }
//
//        guard let encoded = stack.popMap() as? M else {
//            let context = EncodingError.Context(
//                debugDescription: "Encoder did not encode to the requested type \(M.self)."
//            )
//
//            throw EncodingError.invalidValue(self, context)
//        }
//
//        return encoded
//    }
//}
//
//fileprivate final class MapKeyedEncodingContainer<M : Map, K : CodingKey> : KeyedEncodingContainerProtocol {
//    typealias Key = K
//    let encoder: MapEncoder<M>
//    var codingPath: [CodingKey?]
//
//    init(
//        referencing encoder: MapEncoder<M>,
//        codingPath: [CodingKey?]
//    ) {
//        self.encoder = encoder
//        self.codingPath = codingPath
//    }
//
//    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
//        codingPath.append(key)
//        let result: T = try work()
//        codingPath.removeLast()
//        return result
//    }
//
//    func encode(_ value: Bool, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(bool: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: Int, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(int: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: Int8, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(int8: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: Int16, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(int16: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: Int32, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(int32: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: Int64, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(int64: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: UInt, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(uint: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: UInt8, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(uint8: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: UInt16, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(uint16: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: UInt32, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(uint32: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: UInt64, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(uint64: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: Float, forKey key: Key)  throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(float: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: Double, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(double: value), forKey: key)
//        }
//    }
//
//    func encode(_ value: String, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(M(string: value), forKey: key)
//        }
//    }
//
//    func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
//        try encoder.with(pushedKey: key) {
//            try encoder.stack.set(encoder.box(value), forKey: key)
//        }
//    }
//
//    func nestedContainer<NestedKey>(
//        keyedBy keyType: NestedKey.Type,
//        forKey key: Key
//    ) -> KeyedEncodingContainer<NestedKey> {
//        do {
//            try encoder.stack.set(M.makeKeyedContainer(), forKey: key)
//        } catch {
//            fatalError("return a failure container")
//        }
//
//        return with(pushedKey: key) {
//            let container = MapKeyedEncodingContainer<M, NestedKey>(
//                referencing: encoder,
//                codingPath: codingPath
//            )
//
//            return KeyedEncodingContainer(container)
//        }
//    }
//
//    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
//        do {
//            try encoder.stack.set(M.makeUnkeyedContainer(), forKey: key)
//        } catch {
//            fatalError("return a failure container")
//        }
//
//        return with(pushedKey: key) {
//            return MapUnkeyedEncodingContainer(
//                referencing: encoder,
//                codingPath: codingPath
//            )
//        }
//    }
//
//    func superEncoder() -> Encoder {
//        return MapReferencingEncoder(referencing: encoder, at: MapSuperKey.super) { value in
//            try self.encoder.stack.set(value, forKey: MapSuperKey.super)
//        }
//    }
//
//    func superEncoder(forKey key: Key) -> Encoder {
//        return MapReferencingEncoder(referencing: encoder, at: key) { value in
//            try self.encoder.stack.set(value, forKey: key)
//        }
//    }
//}
//
//fileprivate final class MapUnkeyedEncodingContainer<M : Map> : UnkeyedEncodingContainer {
//    let encoder: MapEncoder<M>
//    var codingPath: [CodingKey?]
//
//    init(
//        referencing encoder: MapEncoder<M>,
//        codingPath: [CodingKey?]
//    ) {
//        self.encoder = encoder
//        self.codingPath = codingPath
//    }
//
//    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
//        codingPath.append(key)
//        let result: T = try work()
//        codingPath.removeLast()
//        return result
//    }
//
//    func encode(_ value: Bool) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(bool: value))
//        }
//    }
//
//    func encode(_ value: Int) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(int: value))
//        }
//    }
//
//    func encode(_ value: Int8) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(int8: value))
//        }
//    }
//
//    func encode(_ value: Int16) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(int16: value))
//        }
//    }
//
//    func encode(_ value: Int32) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(int32: value))
//        }
//    }
//
//    func encode(_ value: Int64) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(int64: value))
//        }
//    }
//
//    func encode(_ value: UInt) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(uint: value))
//        }
//    }
//
//    func encode(_ value: UInt8) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(uint8: value))
//        }
//    }
//
//    func encode(_ value: UInt16) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(uint16: value))
//        }
//    }
//
//    func encode(_ value: UInt32) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(uint32: value))
//        }
//    }
//
//    func encode(_ value: UInt64) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(uint64: value))
//        }
//    }
//
//    func encode(_ value: Float)  throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(float: value))
//        }
//    }
//
//    func encode(_ value: Double) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(M(double: value))
//        }
//    }
//
//    func encode(_ value: String) throws {
//        try encoder.stack.append(M(string: value))
//    }
//
//    func encode<T : Encodable>(_ value: T) throws {
//        try encoder.with(pushedKey: nil) {
//            try encoder.stack.append(encoder.box(value))
//        }
//    }
//
//    func nestedContainer<NestedKey>(
//        keyedBy keyType: NestedKey.Type
//    ) -> KeyedEncodingContainer<NestedKey> {
//        do {
//            try encoder.stack.append(M.makeKeyedContainer())
//        } catch {
//            fatalError("return a failure container")
//        }
//
//        return with(pushedKey: nil) {
//            let container = MapKeyedEncodingContainer<M, NestedKey>(
//                referencing: encoder,
//                codingPath: codingPath
//            )
//
//            return KeyedEncodingContainer(container)
//        }
//    }
//
//    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
//        do {
//            try encoder.stack.append(M.makeUnkeyedContainer())
//        } catch {
//            fatalError("return a failure container")
//        }
//
//        return with(pushedKey: nil) {
//            return MapUnkeyedEncodingContainer(
//                referencing: encoder,
//                codingPath: codingPath
//            )
//        }
//    }
//
//    func superEncoder() -> Encoder {
//        return MapReferencingEncoder(referencing: encoder, at: nil) { value in
//            try self.encoder.stack.append(value)
//        }
//    }
//}
//
//extension MapEncoder : SingleValueEncodingContainer {
//    func assertCanEncodeSingleValue() {
//        guard canEncodeNewElement else {
//            preconditionFailure("Attempt to encode with new container when already encoded with a container.")
//        }
//    }
//
//    func encodeNil() throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(null: ()))
//    }
//
//    func encode(_ value: Bool) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(bool: value))
//    }
//
//    func encode(_ value: Int) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(int: value))
//    }
//
//    func encode(_ value: Int8) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(int8: value))
//    }
//
//    func encode(_ value: Int16) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(int16: value))
//    }
//
//    func encode(_ value: Int32) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(int32: value))
//    }
//
//    func encode(_ value: Int64) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(int64: value))
//    }
//
//    func encode(_ value: UInt) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(uint: value))
//    }
//
//    func encode(_ value: UInt8) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(uint8: value))
//    }
//
//    func encode(_ value: UInt16) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(uint16: value))
//    }
//
//    func encode(_ value: UInt32) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(uint32: value))
//    }
//
//    func encode(_ value: UInt64) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(uint64: value))
//    }
//
//    func encode(_ value: Float) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(float: value))
//    }
//
//    func encode(_ value: Double) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(double: value))
//    }
//
//    func encode(_ value: String) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: M(string: value))
//    }
//
//    func encode<T : Encodable>(_ value: T) throws {
//        assertCanEncodeSingleValue()
//        try stack.push(map: box(value))
//    }
//}
//
//extension MapEncoder {
//    fileprivate func box<T : Encodable>(_ value: T) throws -> Map {
//        let count = stack.count
//        try value.encode(to: self)
//
//        guard stack.count != count else {
//            return try M.makeKeyedContainer()
//        }
//
//        return stack.popMap()
//    }
//}
//
//fileprivate class MapReferencingEncoder<M : Map> : MapEncoder<M> {
//    let encoder: MapEncoder<M>
//    let write: (Map) throws -> Void
//
//    init(
//        referencing encoder: MapEncoder<M>,
//        at key: CodingKey?,
//        write: @escaping (Map) throws -> Void
//    ) {
//        self.encoder = encoder
//        self.write = write
//        super.init(codingPath: encoder.codingPath, userInfo: encoder.userInfo)
//        self.codingPath.append(key)
//    }
//
//    override var canEncodeNewElement: Bool {
//        // With a regular encoder, the storage and coding path grow together.
//        // A referencing encoder, however, inherits its parents coding path, as well as the key it was created for.
//        // We have to take this into account.
//        return stack.count == codingPath.count - encoder.codingPath.count - 1
//    }
//
//    deinit {
//        let value: Map
//
//        switch stack.count {
//        case 0: value = try! M.makeKeyedContainer()
//        case 1: value = stack.popMap()
//        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
//        }
//
//        do {
//            try write(value)
//        } catch {
//            fatalError("Could not write to container.")
//        }
//    }
//}

enum MapSuperKey : String, CodingKey {
    case `super`
}

