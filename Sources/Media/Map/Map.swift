public protocol EncodingMap {
    static func makeKeyedContainer() throws -> EncodingMap
    static func makeUnkeyedContainer() throws -> EncodingMap
    
    init(array: [EncodingMap]) throws
    
    init(null: Void) throws
    init(bool: Bool) throws
    init(int: Int) throws
    init(int8: Int8) throws
    init(int16: Int16) throws
    init(int32: Int32) throws
    init(int64: Int64) throws
    init(uint: UInt) throws
    init(uint8: UInt8) throws
    init(uint16: UInt16) throws
    init(uint32: UInt32) throws
    init(uint64: UInt64) throws
    init(float: Float) throws
    init(double: Double) throws
    init(string: String) throws
    
    mutating func set(_ value: EncodingMap, forKeys keys: [CodingKey]) throws
    mutating func append(_ value: EncodingMap) throws
}

extension String : CodingKey {
    public var stringValue: String {
        return self
    }
    
    public init?(stringValue: String) {
        self = stringValue
    }
    
    public var intValue: Int? {
        return Int(self)
    }
    
    public init?(intValue: Int) {
        self = String(intValue)
    }
}

extension Int : CodingKey {
    public var stringValue: String {
        return description
    }
    
    public init?(stringValue: String) {
        guard let int = Int(stringValue) else {
            return nil
        }
        
        self = int
    }
    
    public var intValue: Int? {
        return self
    }
    
    public init?(intValue: Int) {
        self = intValue
    }
}

extension EncodingError.Context {
    public init(codingPath: [CodingKey?] = []) {
        self.codingPath = codingPath
        self.debugDescription = ""
    }
    
    public init(debugDescription: String) {
        self.codingPath = []
        self.debugDescription = debugDescription
    }
}

extension DecodingError.Context {
    public init(codingPath: [CodingKey?] = []) {
        self.codingPath = codingPath
        self.debugDescription = ""
    }
    
    public init(debugDescription: String) {
        self.codingPath = []
        self.debugDescription = debugDescription
    }
}
