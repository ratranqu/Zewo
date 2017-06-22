//===----------------------------------------------------------------------===//
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0
//
//===----------------------------------------------------------------------===//

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
//    /// Encodes the given top-level value and returns its Map representation.
//    ///
//    /// - parameter value: The value to encode.
//    /// - returns: A new `Map` value containing the encoded Map data.
//    /// - throws: `EncodingError.invalidValue` if a non-comforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
//    /// - throws: An error if any value throws an error during encoding.
//    public func encode<T : Encodable, M : Map>(_ value: T) throws -> M {
//        let encoder = MapEncoder(options: options)
//        try value.encode(to: encoder)
//
//        guard encoder.storage.count > 0 else {
//            let context = EncodingError.Context(
//                codingPath: [],
//                debugDescription: "Top-level \(T.self) did not encode any values."
//            )
//
//            throw EncodingError.invalidValue(value, context)
//        }
//
//        return encoder.storage.popContainer()
//    }
}

extension MapCoder {
    /// Decodes a top-level value of the given type from the given Map representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter Map: The Map data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid Map.
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

////===----------------------------------------------------------------------===//
//// Map Encoder
////===----------------------------------------------------------------------===//
//
//fileprivate class MapEncoder<M : Map> : Encoder {
//    /// The encoder's storage.
//    var storage: MapEncodingStorage<M>
//
//    /// Options set on the top-level encoder.
//    let options: MapCoder.Options
//
//    /// The path to the current point in encoding.
//    var codingPath: [CodingKey?]
//
//    /// Contextual user-provided information for use during encoding.
//    var userInfo: [CodingUserInfoKey : Any] {
//        return self.options.userInfo
//    }
//
//    /// Initializes `self` with the given top-level encoder options.
//    init(options: MapCoder.Options, codingPath: [CodingKey?] = []) {
//        self.options = options
//        self.storage = MapEncodingStorage()
//        self.codingPath = codingPath
//    }
//
//    /// Performs the given closure with the given key pushed onto the end of the current coding path.
//    ///
//    /// - parameter key: The key to push. May be nil for unkeyed containers.
//    /// - parameter work: The work to perform with the key in the path.
//    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
//        self.codingPath.append(key)
//        let ret: T = try work()
//        self.codingPath.removeLast()
//        return ret
//    }
//
//    /// Returns whether a new element can be encoded at this coding path.
//    ///
//    /// `true` if an element has not yet been encoded at this coding path; `false` otherwise.
//    var canEncodeNewElement: Bool {
//        // Every time a new value gets encoded, the key it's encoded for is pushed onto the coding path (even if it's a nil key from an unkeyed container).
//        // At the same time, every time a container is requested, a new value gets pushed onto the storage stack.
//        // If there are more values on the storage stack than on the coding path, it means the value is requesting more than one container, which violates the precondition.
//        //
//        // This means that anytime something that can request a new container goes onto the stack, we MUST push a key onto the coding path.
//        // Things which will not request containers do not need to have the coding path extended for them (but it doesn't matter if it is, because they will not reach here).
//        return self.storage.count == self.codingPath.count
//    }
//
//    /// Asserts that a new container can be requested at this coding path.
//    /// `preconditionFailure()`s if one cannot be requested.
//    func assertCanRequestNewContainer() {
//        guard self.canEncodeNewElement else {
//            let previousContainerType: String
//
//            if self.storage.containers.last?.isObject == true {
//                previousContainerType = "keyed"
//            } else if self.storage.containers.last?.isArray == true {
//                previousContainerType = "unkeyed"
//            } else {
//                previousContainerType = "single value"
//            }
//
//            preconditionFailure("Attempt to encode with new container when already encoded with \(previousContainerType) container.")
//        }
//    }
//
//    func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
//        assertCanRequestNewContainer()
//        self.storage.pushKeyedContainer()
//
//        let container = MapKeyedEncodingContainer<Key>(
//            referencing: self,
//            codingPath: self.codingPath
//        )
//
//        return KeyedEncodingContainer(container)
//    }
//
//    func unkeyedContainer() -> UnkeyedEncodingContainer {
//        assertCanRequestNewContainer()
//        self.storage.pushUnkeyedContainer()
//
//        return MapUnkeyedEncodingContainer(
//            referencing: self,
//            codingPath: self.codingPath
//        )
//    }
//
//    func singleValueContainer() -> SingleValueEncodingContainer {
//        assertCanRequestNewContainer()
//        return self
//    }
//}
//
//fileprivate struct MapEncodingStorage<M : Map> {
//    /// The container stack.
//    /// Elements may be any one of the Map types (NSNull, NSNumber, NSString, NSArray, NSDictionary).
//    private(set) var containers: [M] = []
//
//    /// Initializes `self` with no containers.
//    init() {}
//
//    var count: Int {
//        return self.containers.count
//    }
//
//    mutating func pushKeyedContainer() throws {
//        try self.containers.append(M.keyedContainer())
//    }
//
//    mutating func set(_ value: M, forKey key: String) {
//        guard let top = self.containers.popLast() else {
//            return
//        }
//
//        guard case var .object(object) = top else {
//            return
//        }
//
//        object[key] = value
//
//        self.containers.append(.object(object))
//    }
//
//    mutating func append(_ value: M) {
//        guard let top = self.containers.popLast() else {
//            return
//        }
//
//        guard case var .array(array) = top else {
//            return
//        }
//
//        array.append(value)
//
//        self.containers.append(.array(array))
//    }
//
//    mutating func pushUnkeyedContainer() throws {
//        try self.containers.append(M.unkeyedContainer())
//    }
//
//    mutating func push(container: M) {
//        self.containers.append(container)
//    }
//
//    mutating func popContainer() -> M {
//        precondition(self.containers.count > 0, "Empty container stack.")
//        return self.containers.popLast()!
//    }
//}
//
//fileprivate final class MapKeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
//    typealias Key = K
//
//    /// A reference to the encoder we're writing to.
//    let encoder: MapEncoder
//
//    /// The path of coding keys taken to get to this point in encoding.
//    var codingPath: [CodingKey?]
//
//    /// Initializes `self` with the given references.
//    init(
//        referencing encoder: MapEncoder,
//        codingPath: [CodingKey?]
//    ) {
//        self.encoder = encoder
//        self.codingPath = codingPath
//    }
//
//    /// Performs the given closure with the given key pushed onto the end of the current coding path.
//    ///
//    /// - parameter key: The key to push. May be nil for unkeyed containers.
//    /// - parameter work: The work to perform with the key in the path.
//    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
//        self.codingPath.append(key)
//        let ret: T = try work()
//        self.codingPath.removeLast()
//        return ret
//    }
//
//    func encode(_ value: Bool, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: Int, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: Int8, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: Int16, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: Int32, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: Int64, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: UInt, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: UInt8, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: UInt16, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: UInt32, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: UInt64, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: String, forKey key: Key) throws {
//        self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//    }
//
//    func encode(_ value: Float, forKey key: Key)  throws {
//        // Since the float may be invalid and throw, the coding path needs to contain this key.
//        try self.encoder.with(pushedKey: key) {
//            try self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//        }
//    }
//
//    func encode(_ value: Double, forKey key: Key) throws {
//        // Since the double may be invalid and throw, the coding path needs to contain this key.
//        try self.encoder.with(pushedKey: key) {
//            try self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//        }
//    }
//
//    func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
//        try self.encoder.with(pushedKey: key) {
//            try self.encoder.storage.set(self.encoder.box(value), forKey: key.stringValue)
//        }
//    }
//
//    func nestedContainer<NestedKey>(
//        keyedBy keyType: NestedKey.Type,
//        forKey key: Key
//        ) -> KeyedEncodingContainer<NestedKey> {
//        self.encoder.storage.set([:], forKey: key.stringValue)
//
//        return self.with(pushedKey: key) {
//            let container = MapKeyedEncodingContainer<NestedKey>(
//                referencing: self.encoder,
//                codingPath: self.codingPath
//            )
//
//            return KeyedEncodingContainer(container)
//        }
//    }
//
//    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
//        self.encoder.storage.set([], forKey: key.stringValue)
//
//        return self.with(pushedKey: key) {
//            return MapUnkeyedEncodingContainer(
//                referencing: self.encoder,
//                codingPath: self.codingPath
//            )
//        }
//    }
//
//    func superEncoder() -> Encoder {
//        return MapReferencingEncoder(referencing: self.encoder, at: MapSuperKey.super) { value in
//            self.encoder.storage.set(value, forKey: MapSuperKey.super.stringValue)
//        }
//    }
//
//    func superEncoder(forKey key: Key) -> Encoder {
//        return MapReferencingEncoder(referencing: self.encoder, at: key) { value in
//            self.encoder.storage.set(value, forKey: key.stringValue)
//        }
//    }
//}
//
//fileprivate final class MapUnkeyedEncodingContainer : UnkeyedEncodingContainer {
//    /// A reference to the encoder we're writing to.
//    let encoder: MapEncoder
//
//    /// The path of coding keys taken to get to this point in encoding.
//    var codingPath: [CodingKey?]
//
//    /// Initializes `self` with the given references.
//    init(
//        referencing encoder: MapEncoder,
//        codingPath: [CodingKey?]
//    ) {
//        self.encoder = encoder
//        self.codingPath = codingPath
//    }
//
//    /// Performs the given closure with the given key pushed onto the end of the current coding path.
//    ///
//    /// - parameter key: The key to push. May be nil for unkeyed containers.
//    /// - parameter work: The work to perform with the key in the path.
//    func with<T>(pushedKey key: CodingKey?, _ work: () throws -> T) rethrows -> T {
//        self.codingPath.append(key)
//        let ret: T = try work()
//        self.codingPath.removeLast()
//        return ret
//    }
//
//    func encode(_ value: Bool) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: Int) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: Int8) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: Int16) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: Int32) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: Int64) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: UInt) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: UInt8) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: UInt16) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: UInt32) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: UInt64) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: String) throws {
//        self.encoder.storage.append(self.encoder.box(value))
//    }
//
//    func encode(_ value: Float)  throws {
//        // Since the float may be invalid and throw, the coding path needs to contain this key.
//        try self.encoder.with(pushedKey: nil) {
//            try self.encoder.storage.append(self.encoder.box(value))
//        }
//    }
//
//    func encode(_ value: Double) throws {
//        // Since the double may be invalid and throw, the coding path needs to contain this key.
//        try self.encoder.with(pushedKey: nil) {
//            try self.encoder.storage.append(self.encoder.box(value))
//        }
//    }
//
//    func encode<T : Encodable>(_ value: T) throws {
//        try self.encoder.with(pushedKey: nil) {
//            try self.encoder.storage.append(self.encoder.box(value))
//        }
//    }
//
//    func nestedContainer<NestedKey>(
//        keyedBy keyType: NestedKey.Type
//    ) -> KeyedEncodingContainer<NestedKey> {
//        self.encoder.storage.append([:])
//
//        return self.with(pushedKey: nil) {
//            let container = MapKeyedEncodingContainer<NestedKey>(
//                referencing: self.encoder,
//                codingPath: self.codingPath
//            )
//
//            return KeyedEncodingContainer(container)
//        }
//    }
//
//    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
//        self.encoder.storage.append([])
//
//        return self.with(pushedKey: nil) {
//            return MapUnkeyedEncodingContainer(
//                referencing: self.encoder,
//                codingPath: self.codingPath
//            )
//        }
//    }
//
//    func superEncoder() -> Encoder {
//        return MapReferencingEncoder(referencing: self.encoder, at: nil) { value in
//            self.encoder.storage.append(value)
//        }
//    }
//}
//
//extension MapEncoder : SingleValueEncodingContainer {
//    // MARK: - Utility Methods
//    /// Asserts that a single value can be encoded at the current coding path (i.e. that one has not already been encoded through this container).
//    /// `preconditionFailure()`s if one cannot be encoded.
//    ///
//    /// This is similar to assertCanRequestNewContainer above.
//    func assertCanEncodeSingleValue() {
//        guard self.canEncodeNewElement else {
//            let previousContainerType: String
//            if self.storage.containers.last?.isObject == true {
//                previousContainerType = "keyed"
//            } else if self.storage.containers.last?.isArray == true {
//                previousContainerType = "unkeyed"
//            } else {
//                preconditionFailure("Attempt to encode multiple values in a single value container.")
//            }
//
//            preconditionFailure("Attempt to encode with new container when already encoded with \(previousContainerType) container.")
//        }
//    }
//
//    // MARK: - SingleValueEncodingContainer Methods
//    func encodeNil() throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: .null)
//    }
//
//    func encode(_ value: Bool) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: Int) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: Int8) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: Int16) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: Int32) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: Int64) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: UInt) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: UInt8) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: UInt16) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: UInt32) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: UInt64) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: String) throws {
//        assertCanEncodeSingleValue()
//        self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: Float) throws {
//        assertCanEncodeSingleValue()
//        try self.storage.push(container: box(value))
//    }
//
//    func encode(_ value: Double) throws {
//        assertCanEncodeSingleValue()
//        try self.storage.push(container: box(value))
//    }
//
//    func encode<T : Encodable>(_ value: T) throws {
//        assertCanEncodeSingleValue()
//        try self.storage.push(container: box(value))
//    }
//}
//
//// MARK: - Concrete Value Representations
//extension MapEncoder {
////    /// Returns the given value boxed in a container appropriate for pushing onto the container stack.
////    fileprivate func box(_ value: Bool)   -> Map { return .bool(value) }
////    fileprivate func box(_ value: Int)    -> Map { return .int(value) }
////    fileprivate func box(_ value: Int8)   -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: Int16)  -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: Int32)  -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: Int64)  -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: UInt)   -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: UInt8)  -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: UInt16) -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: UInt32) -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: UInt64) -> Map { return .int(Int(value)) }
////    fileprivate func box(_ value: String) -> Map { return .string(value) }
////
////    fileprivate func box(_ float: Float) throws -> Map {
////        guard !float.isInfinite && !float.isNaN else {
////            guard case let .convert(
////                positiveInfinity: posInfString,
////                negativeInfinity: negInfString,
////                nan: nanString
////                ) = self.options.nonConformingFloatCodingStrategy else {
////                    throw EncodingError._invalidFloatingPointValue(float, at: codingPath)
////            }
////
////            if float == Float.infinity {
////                return .string(posInfString)
////            } else if float == -Float.infinity {
////                return .string(negInfString)
////            } else {
////                return .string(nanString)
////            }
////        }
////
////        return .double(Double(float))
////    }
////
////    fileprivate func box(_ double: Double) throws -> Map {
////        guard !double.isInfinite && !double.isNaN else {
////            guard case let .convert(
////                positiveInfinity: posInfString,
////                negativeInfinity: negInfString,
////                nan: nanString
////                ) = self.options.nonConformingFloatCodingStrategy else {
////                    throw EncodingError._invalidFloatingPointValue(double, at: codingPath)
////            }
////
////            if double == Double.infinity {
////                return .string(posInfString)
////            } else if double == -Double.infinity {
////                return .string(negInfString)
////            } else {
////                return .string(nanString)
////            }
////        }
////
////        return .double(double)
////    }
////
////    fileprivate func box(_ date: Date) throws -> Map {
////        switch self.options.dateCodingStrategy {
////            //        case .deferredToDate:
////            //            // Must be called with a surrounding with(pushedKey:) call.
////            //            try date.encode(to: self)
////            //            return self.storage.popContainer()
////
////        case .secondsSince1970:
////            return .double(date.timeIntervalSince1970)
////
////        case .millisecondsSince1970:
////            return .double(1000.0 * date.timeIntervalSince1970)
////
////        case .iso8601:
////            if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
////                return .string(_iso8601Formatter.string(from: date))
////            } else {
////                fatalError("ISO8601DateFormatter is unavailable on this platform.")
////            }
////
////        case .formatted(let formatter):
////            return .string(formatter.string(from: date))
////
////        case .custom(let encode, _):
////            let depth = self.storage.count
////            try encode(date, self)
////
////            guard self.storage.count > depth else {
////                // The closure didn't encode anything. Return the default keyed container.
////                return [:]
////            }
////
////            // We can pop because the closure encoded something.
////            return self.storage.popContainer()
////        }
////    }
////
////    fileprivate func box(_ data: Data) throws -> Map {
////        switch self.options.dataCodingStrategy {
////        case .base64:
////            return .string(data.base64EncodedString())
////
////        case .custom(let encode, _):
////            let depth = self.storage.count
////            try encode(data, self)
////
////            guard self.storage.count > depth else {
////                // The closure didn't encode anything. Return the default keyed container.
////                return [:]
////            }
////
////            // We can pop because the closure encoded something.
////            return self.storage.popContainer()
////        }
////    }
//
//    fileprivate func box<T : Encodable>(_ value: T) throws -> Map {
//        if T.self == Date.self {
//            // Respect Date encoding strategy
//            return try self.box((value as! Date))
//        } else if T.self == Data.self {
//            // Respect Data encoding strategy
//            return try self.box((value as! Data))
//        } else if T.self == URL.self {
//            // Encode URLs as single strings.
//            return self.box((value as! URL).absoluteString)
//        }
//
//        // The value should request a container from the _MapEncoder.
//        let topContainer = self.storage.containers.last
//        try value.encode(to: self)
//
//
//        // TODO: Figure this out!
//        //
//        //        // The top container should be a new container.
//        //        guard self.storage.containers.last! !== topContainer else {
//        //            // If the value didn't request a container at all, encode the default container instead.
//        //            return [:]
//        //        }
//
//        return self.storage.popContainer()
//    }
//}
//
///// _MapReferencingEncoder is a special subclass of _MapEncoder which has its own storage, but references the contents of a different encoder.
///// It's used in superEncoder(), which returns a new encoder for encoding a superclass -- the lifetime of the encoder should not escape the scope it's created in, but it doesn't necessarily know when it's done being used (to write to the original container).
//fileprivate class MapReferencingEncoder<M : Map> : MapEncoder<M> {
//    /// The encoder we're referencing.
//    let encoder: MapEncoder<M>
//
//    /// Function that writes the contents of our storage to the referenced encoder's storage.
//    let write: (Map) -> Void
//
//    /// Initializes `self` by referencing the given array container in the given encoder.
//    init(referencing encoder: MapEncoder<M>, at key: CodingKey?, write: @escaping (Map) -> Void) {
//        self.encoder = encoder
//        self.write = write
//        super.init(options: encoder.options, codingPath: encoder.codingPath)
//        self.codingPath.append(key)
//    }
//
//    override var canEncodeNewElement: Bool {
//        // With a regular encoder, the storage and coding path grow together.
//        // A referencing encoder, however, inherits its parents coding path, as well as the key it was created for.
//        // We have to take this into account.
//        return self.storage.count == self.codingPath.count - self.encoder.codingPath.count - 1
//    }
//
//    // Finalizes `self` by writing the contents of our storage to the referenced encoder's storage.
//    deinit {
//        let value: Map
//
//        switch self.storage.count {
//        case 0: value = try! M.keyedContainer()
//        case 1: value = self.storage.popContainer()
//        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
//        }
//
//        self.write(value)
//    }
//}

//===----------------------------------------------------------------------===//
// Map Decoder
//===----------------------------------------------------------------------===//

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
//        guard !self.storage.topContainer.isNull else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Cannot get keyed decoding container -- found null value instead."
//            )
//
//            throw DecodingError.valueNotFound(KeyedDecodingContainer<Key>.self, context)
//        }
//
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
//        guard !self.storage.topContainer.isNull else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Cannot get unkeyed decoding container -- found null value instead."
//            )
//
//            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
//        }
//
//        guard case let .array(array) = self.storage.topContainer else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: [Any].self,
//                reality: self.storage.topContainer
//            )
//        }
        
        guard let array = try self.storage.topContainer.arrayValue() else {
            throw DecodingError._typeMismatch(
                at: codingPath,
                expectation: [Map].self,
                reality: storage.topContainer
            )
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
        return self.containers.count
    }
    
    var topContainer: M {
        precondition(self.containers.count > 0, "Empty container stack.")
        return self.containers.last!
    }
    
    mutating func push(container: M) {
        self.containers.append(container)
    }
    
    mutating func popContainer() {
        precondition(self.containers.count > 0, "Empty container stack.")
        self.containers.removeLast()
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
        return []
        // TODO: Check this
//        return self.container.keys.flatMap { Key(stringValue: $0) }
    }
    
    func contains(_ key: Key) -> Bool {
        let key = decoder.key(for: key)
        return try! container.value(forKeys: key) != nil
    }
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
        return try decoder.with(pushedKey: key) { key in
            return try container.boolValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
        return try decoder.with(pushedKey: key) { key in
            return try container.intValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.int8Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.int16Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.int32Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.int64Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.uintValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.uint8Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.uint16Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.uint32Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.uint64Value(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.floatValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
        return try self.decoder.with(pushedKey: key) { key in
            return try container.doubleValue(forKeys: key)
        }
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
        return try decoder.with(pushedKey: key) { key in
            return try container.stringValue(forKeys: key)
        }
    }
    
//    func decodeIfPresent(_ type: Data.Type, forKey key: Key) throws -> Data? {
//        return try self.decoder.with(pushedKey: key) {
//            let key = MapCoder.encode(field: key.stringValue, policy: decoder.options.fieldNamingPolicy)
//            return try self.decoder.unbox(self.container[key], as: Data.self)
//        }
//    }
    
    func decodeIfPresent<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T? {
        return try self.decoder.with(pushedKey: key) { key in
            return try self.decoder.unbox(container.value(forKeys: key), as: T.self)
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        return try self.decoder.with(pushedKey: key) { keyString in
            
            guard let value = try self.container.value(forKeys: keyString) else {
                let context = DecodingError.Context(
                    codingPath: self.codingPath,
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
                referencing: self.decoder,
                wrapping: value
            )
            
            return KeyedDecodingContainer(container)
        }
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return try self.decoder.with(pushedKey: key) { keyString in
            
            guard let value = try self.container.arrayValue(forKeys: keyString) else {
                let context = DecodingError.Context(
                    codingPath: self.codingPath,
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
                referencing: self.decoder,
                wrapping: value
            )
        }
    }
    
    func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        return try self.decoder.with(pushedKey: key) { keyString in
            
            guard let value = try self.container.value(forKeys: keyString) else {
                let context = DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get superDecoder() -- no value found for key \"\(key.stringValue)\""
                )
                
                throw DecodingError.keyNotFound(key, context)
            }
            
            return MapDecoder(
                referencing: value,
                at: self.decoder.codingPath,
                options: self.decoder.options
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
    let container: [Map]
    var codingPath: [CodingKey?]
    var currentIndex: Int
    
    init(referencing decoder: MapDecoder<M>, wrapping container: [Map]) {
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
    
//    mutating func decodeIfPresent(_ type: Data.Type) throws -> Data? {
//        guard !self.isAtEnd else { return nil }
//
//        return try self.decoder.with(pushedKey: nil) {
//            let decoded = try self.decoder.unbox(self.container[self.currentIndex], as: Data.self)
//            self.currentIndex += 1
//            return decoded
//        }
//    }
    
    mutating func decodeIfPresent<T : Decodable>(_ type: T.Type) throws -> T? {
        guard !self.isAtEnd else { return nil }
        
        return try self.decoder.with(pushedKey: nil) {
            let decoded = try self.decoder.unbox(self.container[self.currentIndex] as? M, as: T.self)
            self.currentIndex += 1
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
            
//            guard !value.isNull else {
//                let context = DecodingError.Context(
//                    codingPath: self.codingPath,
//                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
//                )
//
//                throw DecodingError.valueNotFound(KeyedDecodingContainer<NestedKey>.self, context)
//            }
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
                wrapping: value as! M
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
            
//            guard !value.isNull else {
//                let context = DecodingError.Context(
//                    codingPath: self.codingPath,
//                    debugDescription: "Cannot get keyed decoding container -- found null value instead."
//                )
//
//                throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self, context)
//            }
//
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
            guard !self.isAtEnd else {
                let context = DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Cannot get superDecoder() -- unkeyed container is at end."
                )
                
                throw DecodingError.valueNotFound(Decoder.self, context)
            }
            
            let value = self.container[self.currentIndex]
            
//            guard !value.isNull else {
//                let context = DecodingError.Context(
//                    codingPath: self.codingPath,
//                    debugDescription: "Cannot get superDecoder() -- found null value instead."
//                )
//
//                throw DecodingError.valueNotFound(Decoder.self, context)
//            }
            
            self.currentIndex += 1
            
            return MapDecoder<M>(
                referencing: value as! M,
                at: self.decoder.codingPath,
                options: self.decoder.options
            )
        }
    }
}

extension MapDecoder : SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        return try! self.storage.topContainer.value() == nil
//        return self.storage.topContainer.isNull
    }
    
    // These all unwrap the result, since we couldn't have gotten a single value container if the topContainer was null.
    func decode(_ type: Bool.Type) throws -> Bool {
        guard let value = try self.unbox(self.storage.topContainer, as: Bool.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Bool but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Bool.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard let value = try self.unbox(self.storage.topContainer, as: Int.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let value = try self.unbox(self.storage.topContainer, as: Int8.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int8 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int8.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let value = try self.unbox(self.storage.topContainer, as: Int16.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int16 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int16.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let value = try self.unbox(self.storage.topContainer, as: Int32.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int32 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int32.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let value = try self.unbox(self.storage.topContainer, as: Int64.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Int64 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Int64.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        guard let value = try self.unbox(self.storage.topContainer, as: UInt.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let value = try self.unbox(self.storage.topContainer, as: UInt8.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt8 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt8.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let value = try self.unbox(self.storage.topContainer, as: UInt16.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt16 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt16.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let value = try self.unbox(self.storage.topContainer, as: UInt32.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt32 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt32.self, context)
        }
        
        return value
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let value = try self.unbox(self.storage.topContainer, as: UInt64.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected UInt64 but found null value instead."
            )
            
            throw DecodingError.valueNotFound(UInt64.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        guard let value = try self.unbox(self.storage.topContainer, as: Float.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Float but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Float.self, context)
        }
        
        return value
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        guard let value = try self.unbox(self.storage.topContainer, as: Double.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected Double but found null value instead."
            )
            
            throw DecodingError.valueNotFound(Double.self, context)
        }
        
        return value
    }
    
    func decode(_ type: String.Type) throws -> String {
        guard let value = try self.unbox(self.storage.topContainer, as: String.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected String but found null value instead."
            )
            
            throw DecodingError.valueNotFound(String.self, context)
        }
        
        return value
    }
    
    func decode<T : Decodable>(_ type: T.Type) throws -> T {
        
        guard let value = try self.unbox(self.storage.topContainer, as: T.self) else {
            let context = DecodingError.Context(
                codingPath: self.codingPath,
                debugDescription: "Expected \(T.self) but found null value instead."
            )
            
            throw DecodingError.valueNotFound(T.self, context)
        }
        
        return value
    }
}

extension MapDecoder {
//    /// Returns the given value unboxed from a container.
//    fileprivate func unbox(_ value: Map?, as type: Bool.Type) throws -> Bool? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .bool(bool) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        return bool
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: Int.Type) throws -> Int? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        return int
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: Int8.Type) throws -> Int8? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let int8 = Int8(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return int8
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: Int16.Type) throws -> Int16? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let int16 = Int16(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return int16
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: Int32.Type) throws -> Int32? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let int32 = Int32(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return int32
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: Int64.Type) throws -> Int64? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let int64 = Int64(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return int64
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: UInt.Type) throws -> UInt? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let uint = UInt(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return uint
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: UInt8.Type) throws -> UInt8? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let uint8 = UInt8(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return uint8
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: UInt16.Type) throws -> UInt16? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let uint16 = UInt16(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return uint16
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: UInt32.Type) throws -> UInt32? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let uint32 = UInt32(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return uint32
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: UInt64.Type) throws -> UInt64? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .int(int) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        guard let uint64 = UInt64(exactly: int) else {
//            let context = DecodingError.Context(
//                codingPath: self.codingPath,
//                debugDescription: "Parsed Map number <\(int)> does not fit in \(type)."
//            )
//
//            throw DecodingError.dataCorrupted(context)
//        }
//
//        return uint64
//    }
//
//    fileprivate func unbox(_ value: Map?, as type: Float.Type) throws -> Float? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        if case let .double(double) = value {
//            guard let float = Float(exactly: double) else {
//                let context = DecodingError.Context(
//                    codingPath: self.codingPath,
//                    debugDescription: "Parsed Map number \(double) does not fit in \(type)."
//                )
//
//                throw DecodingError.dataCorrupted(context)
//            }
//
//            return float
//        } else if case let .string(string) = value, case .convert(
//            let posInfString,
//            let negInfString,
//            let nanString
//            ) = self.options.nonConformingFloatCodingStrategy {
//            if string == posInfString {
//                return Float.infinity
//            } else if string == negInfString {
//                return -Float.infinity
//            } else if string == nanString {
//                return Float.nan
//            }
//        }
//
//        throw DecodingError._typeMismatch(
//            at: self.codingPath,
//            expectation: type,
//            reality: value
//        )
//    }
//
//    func unbox(_ value: Map?, as type: Double.Type) throws -> Double? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        if case let .double(double) = value {
//            return double
//        } else if case let .string(string) = value, case .convert(
//            let posInfString,
//            let negInfString,
//            let nanString
//            ) = self.options.nonConformingFloatCodingStrategy {
//            if string == posInfString {
//                return Double.infinity
//            } else if string == negInfString {
//                return -Double.infinity
//            } else if string == nanString {
//                return Double.nan
//            }
//        }
//
//        throw DecodingError._typeMismatch(
//            at: self.codingPath,
//            expectation: type,
//            reality: value
//        )
//    }
//
//    func unbox(_ value: Map?, as type: String.Type) throws -> String? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        guard case let .string(string) = value else {
//            throw DecodingError._typeMismatch(
//                at: self.codingPath,
//                expectation: type,
//                reality: value
//            )
//        }
//
//        return string
//    }
//
//    func unbox(_ value: Map?, as type: Date.Type) throws -> Date? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        switch self.options.dateCodingStrategy {
//            //        case .deferredToDate:
//            //            self.storage.push(container: value)
//            //            let date = try Date(from: self)
//            //            self.storage.popContainer()
//            //            return date
//
//        case .secondsSince1970:
//            let double = try self.unbox(value, as: Double.self)!
//            return Date(timeIntervalSince1970: double)
//
//        case .millisecondsSince1970:
//            let double = try self.unbox(value, as: Double.self)!
//            return Date(timeIntervalSince1970: double / 1000.0)
//
//        case .iso8601:
//            if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
//                let string = try self.unbox(value, as: String.self)!
//                guard let date = _iso8601Formatter.date(from: string) else {
//                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected date string to be ISO8601-formatted."))
//                }
//
//                return date
//            } else {
//                fatalError("ISO8601DateFormatter is unavailable on this platform.")
//            }
//
//        case .formatted(let formatter):
//            let string = try self.unbox(value, as: String.self)!
//            guard let date = formatter.date(from: string) else {
//                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Date string does not match format expected by formatter."))
//            }
//
//            return date
//
//        case .custom(_, let decode):
//            self.storage.push(container: value)
//            let date = try decode(self)
//            self.storage.popContainer()
//            return date
//        }
//    }
//
//    func unbox(_ value: Map?, as type: Data.Type) throws -> Data? {
//        guard let value = value else {
//            return nil
//        }
//
//        guard !value.isNull else {
//            return nil
//        }
//
//        switch self.options.dataCodingStrategy {
//        case .base64:
//            guard case let .string(string) = value else {
//                throw DecodingError._typeMismatch(
//                    at: self.codingPath,
//                    expectation: type,
//                    reality: value
//                )
//            }
//
//            guard let data = Data(base64Encoded: string) else {
//                let context = DecodingError.Context(
//                    codingPath: self.codingPath,
//                    debugDescription: "Encountered Data is not valid Base64."
//                )
//
//                throw DecodingError.dataCorrupted(context)
//            }
//
//            return data
//
//        case .custom(_, let decode):
//            self.storage.push(container: value)
//            let data = try decode(self)
//            self.storage.popContainer()
//            return data
//        }
//    }
    
    func unbox<T : Decodable>(_ value: M?, as type: T.Type) throws -> T? {
        guard let value = value else {
            return nil
        }
        
//        guard !value.isNull else {
//            return nil
//        }
//
        let decoded: T
//        if T.self == Date.self {
//            decoded = (try self.unbox(value, as: Date.self) as! T)
//        } else if T.self == Data.self {
//            decoded = (try self.unbox(value, as: Data.self) as! T)
//        } else if T.self == URL.self {
//            guard let urlString = try self.unbox(value, as: String.self) else {
//                return nil
//            }
//
//            guard let url = URL(string: urlString) else {
//                let context = DecodingError.Context(
//                    codingPath: self.codingPath,
//                    debugDescription: "Invalid URL string."
//                )
//
//                throw DecodingError.dataCorrupted(context)
//            }
//
//            decoded = (url as! T)
//        } else {
            self.storage.push(container: value)
            decoded = try T(from: self)
            self.storage.popContainer()
//        }
        
        return decoded
    }
}

//===----------------------------------------------------------------------===//
// Shared Super Key
//===----------------------------------------------------------------------===//

enum MapSuperKey : String, CodingKey {
    case `super`
}

//===----------------------------------------------------------------------===//
// Shared ISO8601 Date Formatter
//===----------------------------------------------------------------------===//

// NOTE: This value is implicitly lazy and _must_ be lazy. We're compiled against the latest SDK (w/ ISO8601DateFormatter), but linked against whichever Foundation the user has. ISO8601DateFormatter might not exist, so we better not hit this code path on an older OS.
@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
var _iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    return formatter
}()

//===----------------------------------------------------------------------===//
// Error Utilities
//===----------------------------------------------------------------------===//

extension EncodingError {
    /// Returns a `.invalidValue` error describing the given invalid floating-point value.
    ///
    ///
    /// - parameter value: The value that was invalid to encode.
    /// - parameter path: The path of `CodingKey`s taken to encode this value.
    /// - returns: An `EncodingError` with the appropriate path and debug description.
    static func _invalidFloatingPointValue<T : FloatingPoint>(
        _ value: T,
        at codingPath: [CodingKey?]
        ) -> EncodingError {
        let valueDescription: String
        
        if value == T.infinity {
            valueDescription = "\(T.self).infinity"
        } else if value == -T.infinity {
            valueDescription = "-\(T.self).infinity"
        } else {
            valueDescription = "\(T.self).nan"
        }
        
        let debugDescription = "Unable to encode \(valueDescription) directly in Map. Use MapEncoder.NonConformingFloatEncodingStrategy.convertToString to specify how the value should be encoded."
        
        let context = EncodingError.Context(
            codingPath: codingPath,
            debugDescription: debugDescription
        )
        
        return .invalidValue(value, context)
    }
}

extension DecodingError {
    /// Returns a `.typeMismatch` error describing the expected type.
    ///
    /// - parameter path: The path of `CodingKey`s taken to decode a value of this type.
    /// - parameter expectation: The type expected to be encountered.
    /// - parameter reality: The value that was encountered instead of the expected type.
    /// - returns: A `DecodingError` with the appropriate path and debug description.
    static func _typeMismatch(
        at path: [CodingKey?],
        expectation: Any.Type,
        reality: Any
        ) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(_typeDescription(of: reality)) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }
    
    /// Returns a description of the type of `value` appropriate for an error message.
    ///
    /// - parameter value: The value whose type to describe.
    /// - returns: A string describing `value`.
    /// - precondition: `value` is one of the types below.
    static func _typeDescription(of value: Any) -> String {
        if value is NSNull {
            return "a null value"
        } else if value is NSNumber /* FIXME: If swift-corelibs-foundation isn't updated to use NSNumber, this check will be necessary: || value is Int || value is Double */ {
            return "a number"
        } else if value is String {
            return "a string/data"
        } else if value is [Any] {
            return "an array"
        } else if value is [String : Any] {
            return "a dictionary"
        } else {
            // This should never happen -- we somehow have a non-Map type here.
            preconditionFailure("Invalid storage type \(type(of: value)).")
        }
    }
}

