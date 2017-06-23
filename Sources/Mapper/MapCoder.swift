import Core
import Foundation

public struct MapCoder {
    /// Naming policy conventions for field names.
    public enum FieldNamingPolicy {
        /// Using this naming policy will ensure that the field name is unchanged.
        case identity
        /// Using this naming policy will ensure that the first "letter" of the Swift property name is capitalized when parsed/serialized to/from its Map form.
        ///
        /// ```
        /// someFieldName -> SomeFieldName
        /// _someFieldName -> _SomeFieldName
        /// aURL -> AURL
        /// aPList -> APList
        /// ```
        case upperCamelCase
        /// Using this naming policy will ensure that the first "letter" of the Swift property name is capitalized when parsed/serialized to/from its Map form and the words will be separated by a space.
        ///
        /// ```
        /// someFieldName -> Some Field Name
        /// _someFieldName -> _Some Field Name
        /// aURL -> A URL
        /// aPList -> A P List
        /// ```
        case upperCamelCaseWithSpaces
        /// Using this naming policy will modify the Swift property name from its camel cased form to a lower case field name where each word is separated by an underscore (_).
        ///
        /// ```
        /// someFieldName -> some_field_name
        /// _someFieldName -> _some_field_name
        /// aURL -> a_url
        /// aPList -> a_p_list
        /// ```
        case snakeCase
        /// Using this naming policy will modify the Swift property name from its camel cased form to a lower case field name where each word is separated by a dash (-).
        ///
        /// ```
        /// someFieldName -> some-field-name
        /// _someFieldName -> _some-field-name
        /// aURL -> a-url
        /// aPList -> a-p-list
        /// ```
        case kebabCase
    }
    
    fileprivate struct Options {
        var fieldNamingPolicy: FieldNamingPolicy
    }
    
    fileprivate let options: Options
    
    public init(fieldNamingPolicy: FieldNamingPolicy = .identity) {
        self.options = Options(fieldNamingPolicy: fieldNamingPolicy)
    }
}

extension MapCoder {
    /// Encodes the given top-level value and returns its Map representation.
    ///
    /// - parameter value: The value to encode.
    /// - returns: A new `Map` value containing the encoded Map data.
    /// - throws: An error if any value throws an error during encoding.
    public func encode<T : Encodable, M : Map>(_ value: T) throws -> M {
        let encoder = MapEncoder<M>(options: options)
        try value.encode(to: encoder)
        
        guard encoder.storage.count > 0 else {
            let context = EncodingError.Context(
                codingPath: [],
                debugDescription: "Top-level \(T.self) did not encode any values."
            )
            
            throw EncodingError.invalidValue(value, context)
        }
        
        return encoder.storage.popContainer()
    }
}

extension MapCoder {
    /// Decodes a top-level value of the given type from the given Map representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter Map: The Map data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    public func decode<T : Decodable, M : Map>(_ map: M) throws -> T {
        let decoder = MapDecoder(referencing: map, options: options)
        return try T(from: decoder)
    }
}

extension MapCoder {
    fileprivate static func encodeUpperCamelCase(field: String) -> String {
        return field.camelCaseSplit().map { word in
            word.uppercasedFirstCharacter()
        }.joined()
    }
    
    fileprivate static func encodeUpperCamelCaseWithSpaces(field: String) -> String {
        return field.camelCaseSplit().map { word in
            word.uppercasedFirstCharacter()
        }.joined(separator: " ")
    }
    
    fileprivate static func encodeLowerCaseWithUnderscores(field: String) -> String {
        return field.camelCaseSplit().map { word in
            word.lowercased()
        }.joined(separator: "_")
    }
    
    fileprivate static func encodeLowerCaseWithDashes(field: String) -> String {
        return field.camelCaseSplit().map { word in
            word.lowercased()
        }.joined(separator: "-")
    }
}

fileprivate class MapEncoder<M : Map> : Encoder {
    var storage: MapEncodingStorage<M>
    let options: MapCoder.Options
    var codingPath: [CodingKey?]
    
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }
    
    init(options: MapCoder.Options, codingPath: [CodingKey?] = []) {
        self.options = options
        self.storage = MapEncodingStorage()
        self.codingPath = codingPath
    }
    
    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
        codingPath.append(key)
        let result: T = try work()
        codingPath.removeLast()
        return result
    }
    
    var canEncodeNewElement: Bool {
        // Every time a new value gets encoded, the key it's encoded for is pushed onto the coding path (even if it's a nil key from an unkeyed container).
        // At the same time, every time a container is requested, a new value gets pushed onto the storage stack.
        // If there are more values on the storage stack than on the coding path, it means the value is requesting more than one container, which violates the precondition.
        //
        // This means that anytime something that can request a new container goes onto the stack, we MUST push a key onto the coding path.
        // Things which will not request containers do not need to have the coding path extended for them (but it doesn't matter if it is, because they will not reach here).
        return storage.count == codingPath.count
    }
    
    func assertCanRequestNewContainer() {
        guard canEncodeNewElement else {
            preconditionFailure("Attempt to encode with new container when already encoded with a container.")
        }
    }
    
    func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        assertCanRequestNewContainer()
        
        do {
            try storage.pushKeyedContainer()
        } catch {
            fatalError("return a failure container")
        }
        
        let container = MapKeyedEncodingContainer<M, Key>(
            referencing: self,
            codingPath: codingPath
        )
        
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        assertCanRequestNewContainer()
        
        do {
            try storage.pushUnkeyedContainer()
        } catch {
            fatalError("return a failure container")
        }
        
        return MapUnkeyedEncodingContainer(
            referencing: self,
            codingPath: self.codingPath
        )
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        assertCanRequestNewContainer()
        return self
    }
}

fileprivate struct MapEncodingStorage<M : Map> {
    private(set) var containers: [M] = []
    
    init() {}
    
    var count: Int {
        return containers.count
    }
    
    mutating func pushKeyedContainer() throws {
        try containers.append(M.keyedContainer())
    }
    
    mutating func set(_ value: M, forKey key: String) throws {
        var top = popContainer()
        try top.set(value, forKeys: key)
        containers.append(top)
    }
    
    mutating func append(_ value: M) throws {
        var top = popContainer()
        try top.append(value)
        self.containers.append(top)
    }
    
    mutating func pushUnkeyedContainer() throws {
        try containers.append(M.unkeyedContainer())
    }
    
    mutating func push(container: M) {
        containers.append(container)
    }
    
    mutating func popContainer() -> M {
        precondition(self.containers.count > 0, "Empty container stack.")
        return containers.popLast()!
    }
}

fileprivate final class MapKeyedEncodingContainer<M : Map, K : CodingKey> : KeyedEncodingContainerProtocol {
    typealias Key = K
    let encoder: MapEncoder<M>
    var codingPath: [CodingKey?]
    
    init(
        referencing encoder: MapEncoder<M>,
        codingPath: [CodingKey?]
    ) {
        self.encoder = encoder
        self.codingPath = codingPath
    }
    
    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
        codingPath.append(key)
        let result: T = try work()
        codingPath.removeLast()
        return result
    }
    
    func encode(_ value: Bool, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(bool: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: Int, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(int: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: Int8, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(int8: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: Int16, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(int16: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: Int32, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(int32: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: Int64, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(int64: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: UInt, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(uint: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: UInt8, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(uint8: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: UInt16, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(uint16: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: UInt32, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(uint32: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: UInt64, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(uint64: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: Float, forKey key: Key)  throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(float: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: Double, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(double: value), forKey: key.stringValue)
        }
    }
    
    func encode(_ value: String, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(M(string: value), forKey: key.stringValue)
        }
    }
    
    func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        try encoder.with(pushedKey: key) {
            try encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
        }
    }
    
    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> {
        do {
            try encoder.storage.set(M.keyedContainer(), forKey: key.stringValue)
        } catch {
            fatalError("return a failure container")
        }
        
        return with(pushedKey: key) {
            let container = MapKeyedEncodingContainer<M, NestedKey>(
                referencing: encoder,
                codingPath: codingPath
            )
            
            return KeyedEncodingContainer(container)
        }
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        do {
            try encoder.storage.set(M.unkeyedContainer(), forKey: key.stringValue)
        } catch {
            fatalError("return a failure container")
        }
        
        return self.with(pushedKey: key) {
            return MapUnkeyedEncodingContainer(
                referencing: encoder,
                codingPath: codingPath
            )
        }
    }
    
    func superEncoder() -> Encoder {
        return MapReferencingEncoder(referencing: self.encoder, at: MapSuperKey.super) { value in
            try self.encoder.storage.set(value, forKey: MapSuperKey.super.stringValue)
        }
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        return MapReferencingEncoder(referencing: self.encoder, at: key) { value in
            try self.encoder.storage.set(value, forKey: key.stringValue)
        }
    }
}

fileprivate final class MapUnkeyedEncodingContainer<M : Map> : UnkeyedEncodingContainer {
    let encoder: MapEncoder<M>
    var codingPath: [CodingKey?]
    
    init(
        referencing encoder: MapEncoder<M>,
        codingPath: [CodingKey?]
    ) {
        self.encoder = encoder
        self.codingPath = codingPath
    }
    
    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
        codingPath.append(key)
        let result: T = try work()
        codingPath.removeLast()
        return result
    }
    
    func encode(_ value: Bool) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(bool: value))
        }
    }
    
    func encode(_ value: Int) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(int: value))
        }
    }
    
    func encode(_ value: Int8) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(int8: value))
        }
    }
    
    func encode(_ value: Int16) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(int16: value))
        }
    }
    
    func encode(_ value: Int32) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(int32: value))
        }
    }
    
    func encode(_ value: Int64) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(int64: value))
        }
    }
    
    func encode(_ value: UInt) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(uint: value))
        }
    }
    
    func encode(_ value: UInt8) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(uint8: value))
        }
    }
    
    func encode(_ value: UInt16) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(uint16: value))
        }
    }
    
    func encode(_ value: UInt32) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(uint32: value))
        }
    }
    
    func encode(_ value: UInt64) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(uint64: value))
        }
    }
    
    func encode(_ value: Float)  throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(float: value))
        }
    }
    
    func encode(_ value: Double) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(M(double: value))
        }
    }
    
    func encode(_ value: String) throws {
        try encoder.storage.append(M(string: value))
    }
    
    func encode<T : Encodable>(_ value: T) throws {
        try encoder.with(pushedKey: nil) {
            try encoder.storage.append(encoder.box(value))
        }
    }
    
    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        do {
            try encoder.storage.append(M.keyedContainer())
        } catch {
            fatalError("return a failure container")
        }
        
        return self.with(pushedKey: nil) {
            let container = MapKeyedEncodingContainer<M, NestedKey>(
                referencing: encoder,
                codingPath: codingPath
            )
            
            return KeyedEncodingContainer(container)
        }
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        do {
            try encoder.storage.append(M.unkeyedContainer())
        } catch {
            fatalError("return a failure container")
        }
        
        return self.with(pushedKey: nil) {
            return MapUnkeyedEncodingContainer(
                referencing: encoder,
                codingPath: codingPath
            )
        }
    }
    
    func superEncoder() -> Encoder {
        return MapReferencingEncoder(referencing: self.encoder, at: nil) { value in
            try self.encoder.storage.append(value)
        }
    }
}

extension MapEncoder : SingleValueEncodingContainer {
    func assertCanEncodeSingleValue() {
        guard canEncodeNewElement else {
            preconditionFailure("Attempt to encode with new container when already encoded with a container.")
        }
    }
    
    func encodeNil() throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(null: ()))
    }
    
    func encode(_ value: Bool) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(bool: value))
    }
    
    func encode(_ value: Int) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(int: value))
    }
    
    func encode(_ value: Int8) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(int8: value))
    }
    
    func encode(_ value: Int16) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(int16: value))
    }
    
    func encode(_ value: Int32) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(int32: value))
    }
    
    func encode(_ value: Int64) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(int64: value))
    }
    
    func encode(_ value: UInt) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(uint: value))
    }
    
    func encode(_ value: UInt8) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(uint8: value))
    }
    
    func encode(_ value: UInt16) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(uint16: value))
    }
    
    func encode(_ value: UInt32) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(uint32: value))
    }
    
    func encode(_ value: UInt64) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(uint64: value))
    }
    
    func encode(_ value: Float) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(float: value))
    }
    
    func encode(_ value: Double) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(double: value))
    }
    
    func encode(_ value: String) throws {
        assertCanEncodeSingleValue()
        try storage.push(container: M(string: value))
    }
    
    func encode<T : Encodable>(_ value: T) throws {
        assertCanEncodeSingleValue()
        try self.storage.push(container: box(value))
    }
}

extension MapEncoder {
    fileprivate func box<T : Encodable>(_ value: T) throws -> M {
        let count = storage.containers.count
        try value.encode(to: self)
        
        guard storage.containers.count != count else {
            return try M.keyedContainer()
        }
        
        return storage.popContainer()
    }
}

fileprivate class MapReferencingEncoder<M : Map> : MapEncoder<M> {
    let encoder: MapEncoder<M>
    let write: (M) throws -> Void
    
    init(referencing encoder: MapEncoder<M>, at key: CodingKey?, write: @escaping (M) throws -> Void) {
        self.encoder = encoder
        self.write = write
        super.init(options: encoder.options, codingPath: encoder.codingPath)
        self.codingPath.append(key)
    }
    
    override var canEncodeNewElement: Bool {
        // With a regular encoder, the storage and coding path grow together.
        // A referencing encoder, however, inherits its parents coding path, as well as the key it was created for.
        // We have to take this into account.
        return storage.count == codingPath.count - encoder.codingPath.count - 1
    }
    
    deinit {
        let value: M
        
        switch storage.count {
        case 0: value = try! M.keyedContainer()
        case 1: value = storage.popContainer()
        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
        }
        
        do {
            try write(value)
        } catch {
            fatalError("Could not write to container.")
        }
    }
}

fileprivate class MapDecoder<M : Map> : Decoder {
    var storage: MapDecodingStorage<M>
    let options: MapCoder.Options
    var codingPath: [CodingKey?]
    
    var userInfo: [CodingUserInfoKey: Any] {
        return [:]
    }
    
    init(
        referencing container: M,
        at codingPath: [CodingKey?] = [],
        options: MapCoder.Options
    ) {
        self.storage = MapDecodingStorage()
        self.storage.push(container: container)
        self.codingPath = codingPath
        self.options = options
    }
    
    func with<T>(pushedKey: CodingKey?, _ work: () throws -> T) rethrows -> T {
        codingPath.append(pushedKey)
        let result: T = try work()
        codingPath.removeLast()
        return result
    }
    
    func with<T>(pushedKey: CodingKey, _ work: (String) throws -> T) rethrows -> T {
        codingPath.append(pushedKey)
        let result: T = try work(key(for: pushedKey))
        codingPath.removeLast()
        return result
    }
    
    fileprivate func key(for codingKey: CodingKey) -> String {
        let key = codingKey.stringValue
        
        switch options.fieldNamingPolicy {
        case .identity:
            return key
        case .upperCamelCase:
            return MapCoder.encodeUpperCamelCase(field: key)
        case .upperCamelCaseWithSpaces:
            return MapCoder.encodeUpperCamelCaseWithSpaces(field: key)
        case .snakeCase:
            return MapCoder.encodeLowerCaseWithUnderscores(field: key)
        case .kebabCase:
            return MapCoder.encodeLowerCaseWithDashes(field: key)
        }
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard !self.storage.topContainer.isNull else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Cannot get keyed decoding container -- found null value instead."
            )
            
            throw DecodingError.valueNotFound(KeyedDecodingContainer<Key>.self, context)
        }
        
//        guard case let .object(object) = self.storage.topContainer else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: [String: Any].self,
//                reality: self.storage.topContainer
//            )
//        }
        
        let container = MapKeyedDecodingContainer<Key, M>(
            referencing: self,
            wrapping: storage.topContainer
        )
        
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard !self.storage.topContainer.isNull else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Cannot get unkeyed decoding container -- found null value instead."
            )
            
            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
        }
        
//        guard case let .array(array) = self.storage.topContainer else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: [Any].self,
//                reality: self.storage.topContainer
//            )
//        }
        
        guard let array = try storage.topContainer.arrayValue() else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Expected to decode array, but value is not an array."
            )
            
            throw DecodingError.typeMismatch([M].self, context)
        }
        
        return MapUnkeyedDecodingContainer<M>(
            referencing: self,
            wrapping: array
        )
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
//        guard !self.storage.topContainer.isObject else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Cannot get single value decoding container -- found keyed container instead."
//            )
//
//            throw DecodingError.typeMismatch(SingleValueDecodingContainer.self, context)
//        }
//
//        guard !self.storage.topContainer.isArray else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Cannot get single value decoding container -- found unkeyed container instead."
//            )
//
//            throw DecodingError.typeMismatch(SingleValueDecodingContainer.self, context)
//        }
        
        return self
    }
}

fileprivate struct MapDecodingStorage<M : Map> {
    private(set) var containers: [M] = []
    
    init() {}
    
    var count: Int {
        return containers.count
    }
    
    var topContainer: M {
        precondition(containers.count > 0, "Empty container stack.")
        return containers.last!
    }
    
    mutating func push(container: M) {
        containers.append(container)
    }
    
    mutating func popContainer() {
        precondition(containers.count > 0, "Empty container stack.")
        containers.removeLast()
    }
}

fileprivate struct MapKeyedDecodingContainer<K : CodingKey, M : Map> : KeyedDecodingContainerProtocol {
    typealias Key = K
    
    let decoder: MapDecoder<M>
    let container: M
    var codingPath: [CodingKey?]
    
    init(referencing decoder: MapDecoder<M>, wrapping container: M) {
        self.decoder = decoder
        self.container = container
        self.codingPath = decoder.codingPath
    }
    
    var allKeys: [Key] {
        return container.keys.flatMap({ Key(stringValue: $0) })
    }
    
    func contains(_ key: Key) -> Bool {
        let key = decoder.key(for: key)
        
        guard let value = try? container.value(forKeys: key) else {
            return false
        }
        
        return value != nil
    }
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
        return try decoder.with(pushedKey: key) { key in
            try container.boolValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
        return try decoder.with(pushedKey: key) { key in
            try container.intValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8? {
        return try decoder.with(pushedKey: key) { key in
            try container.int8Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16? {
        return try decoder.with(pushedKey: key) { key in
            try container.int16Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32? {
        return try decoder.with(pushedKey: key) { key in
            try container.int32Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64? {
        return try decoder.with(pushedKey: key) { key in
            try container.int64Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt? {
        return try decoder.with(pushedKey: key) { key in
            try container.uintValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8? {
        return try decoder.with(pushedKey: key) { key in
            try container.uint8Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16? {
        return try decoder.with(pushedKey: key) { key in
            try container.uint16Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32? {
        return try decoder.with(pushedKey: key) { key in
            try container.uint32Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64? {
        return try decoder.with(pushedKey: key) { key in
            try container.uint64Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
        return try decoder.with(pushedKey: key) { key in
            try container.floatValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
        return try decoder.with(pushedKey: key) { key in
            try container.doubleValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
        return try decoder.with(pushedKey: key) { key in
            try container.stringValue(forKeys: key)
        }
    }
    
    func decodeIfPresent<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T? {
        return try decoder.with(pushedKey: key) { keyString in
            guard let value = try container.value(forKeys: keyString) else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot decoded -- no value found for key \"\(key.stringValue)\""
                )
                
                throw DecodingError.keyNotFound(key, context)
            }
            
            decoder.storage.push(container: value)
            let decoded = try T(from: decoder)
            decoder.storage.popContainer()
            return decoded
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        return try decoder.with(pushedKey: key) { keyString in
            guard let value = try self.container.value(forKeys: keyString) else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get \(KeyedDecodingContainer<NestedKey>.self) -- no value found for key \"\(key.stringValue)\""
                )
                
                throw DecodingError.keyNotFound(key, context)
            }
            
//            guard case let .object(object) = value else {
//                throw DecodingError._typeMismatch(
//                    at: self.codingPath,
//                    expectation: [String : Any].self,
//                    reality: value
//                )
//            }
            
            let container = MapKeyedDecodingContainer<NestedKey, M>(
                referencing: decoder,
                wrapping: value
            )
            
            return KeyedDecodingContainer(container)
        }
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return try decoder.with(pushedKey: key) { keyString in
            guard let value = try self.container.arrayValue(forKeys: keyString) else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get UnkeyedDecodingContainer -- no value found for key \"\(key.stringValue)\""
                )
                
                throw DecodingError.keyNotFound(key, context)
            }
            
//            guard case let .array(array) = value else {
//                throw DecodingError._typeMismatch(
//                    at: self.codingPath,
//                    expectation: [Any].self,
//                    reality: value
//                )
//            }
            
            return MapUnkeyedDecodingContainer(
                referencing: decoder,
                wrapping: value
            )
        }
    }
    
    func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        return try decoder.with(pushedKey: key) { keyString in
            guard let value = try self.container.value(forKeys: keyString) else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get superDecoder() -- no value found for key \"\(key.stringValue)\""
                )
                
                throw DecodingError.keyNotFound(key, context)
            }
            
            return MapDecoder(
                referencing: value,
                at: decoder.codingPath,
                options: decoder.options
            )
        }
    }
    
    func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: MapSuperKey.super)
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }
}

fileprivate struct MapUnkeyedDecodingContainer<M : Map> : UnkeyedDecodingContainer {
    let decoder: MapDecoder<M>
    let container: [M]
    var codingPath: [CodingKey?]
    var currentIndex: Int
    
    init(referencing decoder: MapDecoder<M>, wrapping container: [M]) {
        self.decoder = decoder
        self.container = container
        self.codingPath = decoder.codingPath
        self.currentIndex = 0
    }
    
    var count: Int? {
        return self.container.count
    }
    
    var isAtEnd: Bool {
        return self.currentIndex >= self.count!
    }
    
    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].boolValue()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].intValue()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].int8Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].int16Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].int32Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].int64Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].uintValue()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].uint8Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].uint16Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].uint32Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].uint64Value()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].floatValue()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].doubleValue()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent(_ type: String.Type) throws -> String? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.container[self.currentIndex].stringValue()
            self.currentIndex += 1
            return decoded
        }
    }
    
    mutating func decodeIfPresent<T : Decodable>(_ type: T.Type) throws -> T? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            decoder.storage.push(container: container[currentIndex])
            let decoded = try T(from: decoder)
            decoder.storage.popContainer()
            currentIndex += 1
            return decoded
        }
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> {
        return try self.decoder.with(pushedKey: nil) {
            guard !self.isAtEnd else {
                let context = DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."
                )
                
                throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, context)
            }
            
            let value = self.container[self.currentIndex]
            
            guard !value.isNull else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                )
                
                throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, context)
            }
//
//            guard case let .object(object) = value else {
//                throw DecodingError._typeMismatch(
//                    at: self.codingPath,
//                    expectation: [String : Any].self,
//                    reality: value
//                )
//            }
            
            self.currentIndex += 1
            
            let container = MapKeyedDecodingContainer<NestedKey, M>(
                referencing: self.decoder,
                wrapping: value
            )
            
            return KeyedDecodingContainer(container)
        }
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        return try self.decoder.with(pushedKey: nil) {
            guard !self.isAtEnd else {
                let context = DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get nested keyed container -- unkeyed container is at end."
                )
                
                throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
            }
            
            let value = self.container[self.currentIndex]
            
            guard !value.isNull else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                )
                
                throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
            }
            
//            guard case let .array(array) = value else {
//                throw DecodingError._typeMismatch(
//                    at: self.codingPath,
//                    expectation: [Any].self,
//                    reality: value
//                )
//            }
            
            guard let array = try value.arrayValue() else {
                let context = DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
                )
                
                throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
            }
            
            self.currentIndex += 1
            
            return MapUnkeyedDecodingContainer(
                referencing: self.decoder,
                wrapping: array
            )
        }
    }
    
    mutating func superDecoder() throws -> Decoder {
        return try self.decoder.with(pushedKey: nil) {
            guard !isAtEnd else {
                let context = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."
                )
                
                throw DecodingError.valueNotFound(Decoder.self, context)
            }
            
            let value = container[currentIndex]
            
//            guard !value.isNull else {
//                let context = DecodingError.Context(
//                    codingPath: codingPath,
//                    debugDescription: "Cannot get superDecoder() -- found null value instead."
//                )
//
//                throw DecodingError.valueNotFound(Decoder.self, context)
//            }
            
            currentIndex += 1
            
            return MapDecoder<M>(
                referencing: value,
                at: decoder.codingPath,
                options: decoder.options
            )
        }
    }
}

extension MapDecoder : SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        return storage.topContainer.isNull
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        guard let value = try storage.topContainer.boolValue() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Bool but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Bool.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard let value = try storage.topContainer.intValue() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let value = try storage.topContainer.int8Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int8 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int8.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let value = try storage.topContainer.int16Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int16 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int16.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let value = try storage.topContainer.int32Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int32 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int32.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let value = try storage.topContainer.int64Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int64 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int64.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        guard let value = try storage.topContainer.uintValue() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let value = try storage.topContainer.uint8Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt8 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt8.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let value = try storage.topContainer.uint16Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt16 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt16.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let value = try storage.topContainer.uint32Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt32 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt32.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let value = try storage.topContainer.uint64Value() else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt64 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt64.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        guard let value = try storage.topContainer.floatValue() else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Expected Float but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Float.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        guard let value = try storage.topContainer.doubleValue() else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Expected Double but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Double.self, context)
        }
        
        return value
    }
    
    func decode(_ type: String.Type) throws -> String {
        guard let value = try storage.topContainer.stringValue() else {
            let context = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Expected String but found null value instead."
            )
            
            throw DecodingError.valueNotFound(String.self, context)
        }
        
        return value
    }
    
    func decode<T : Decodable>(_ type: T.Type) throws -> T {
        storage.push(container: storage.topContainer)
        let value = try T(from: self)
        storage.popContainer()
        return value
    }
}

enum MapSuperKey : String, CodingKey {
    case `super`
}
