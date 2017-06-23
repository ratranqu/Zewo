import XCTest
import Foundation
@testable import Mapper

struct Test1 : InputMappable {
    let int: Int
    let string: String
    let double: Double
    let bool: Bool
    
    enum Key : String, MappingKey {
        case int
        case string
        case double
        case bool
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        int = try mapper.map(from: .int)
        string = try mapper.map(from: .string)
        double = try mapper.map(from: .double)
        bool = try mapper.map(from: .bool)
    }
}

struct Nest2 : InputMappable {
    let int: Int
    
    enum Key : String, MappingKey {
        case int
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.int = try mapper.map(from: .int)
    }
}

struct Test2 : InputMappable {
    let string: String
    let ints: [Int]
    let nest: Nest2
    
    enum Key : String, MappingKey {
        case string
        case ints
        case nest
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.string = try mapper.map(from: .string)
        self.ints = try mapper.map(from: .ints)
        self.nest = try mapper.map(from: .nest)
    }
}

struct Test3 : InputMappable {
    let rio: String
    
    enum Key : String, MappingKey {
        case rio = "rio-2016"
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.rio = try mapper.map(from: .rio)
    }
}

struct Test4 : InputMappable {
    let ints: [Int]
    
    enum Key : String, MappingKey {
        case ints
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.ints = try mapper.map(from: .ints)
    }
}

struct Test5 : InputMappable {
    let nests: [Nest2]
    
    enum Key : String, MappingKey {
        case nests
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.nests = try mapper.map(from: .nests)
    }
}

enum StringEnum : String {
    case venice
    case annecy
    case quark
}

enum IntEnum : Int {
    case kharkiv = 1
    case kiev = 2
}

struct Test6 : InputMappable {
    let string: StringEnum
    let int: IntEnum
    
    enum Key : String, MappingKey {
        case string = "next-big-thing"
        case int = "city"
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.string = try mapper.map(from: .string)
        self.int = try mapper.map(from: .int)
    }
}

struct Test7 : InputMappable {
    let strings: [StringEnum]
    let ints: [IntEnum]
    
    enum Key : String, MappingKey {
        case strings = "zewo-projects"
        case ints = "ukraine-capitals"
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.strings = try mapper.map(from: .strings)
        self.ints = try mapper.map(from: .ints)
    }
}

struct Test8 : InputMappable {
    let string: StringEnum
    
    enum Key : String, MappingKey {
        case string = "project"
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.string = try mapper.map(from: .string)
    }
}

enum TestContext {
    case apple
    case peach
    case orange
}

struct Nest3 : ContextInputMappable {
    let int: Int
    
    init<Source>(mapper: ContextualMapper<Source, String, TestContext>) throws {
        switch mapper.context {
        case .apple:
            int = try mapper.map(from: "apple-int")
        case .peach:
            int = try mapper.map(from: "peach-int")
        case .orange:
            int = try mapper.map(from: "orange-int")
        }
    }
}

struct Test9 : ContextInputMappable {
    let nest: Nest3
    
    init<Source>(mapper: ContextualMapper<Source, String, TestContext>) throws {
        self.nest = try mapper.map(from: "nest")
    }
}

struct Test10 : ContextInputMappable {
    let nests: [Nest3]
    
    init<Source>(mapper: ContextualMapper<Source, String, TestContext>) throws {
        self.nests = try mapper.map(from: "nests")
    }
}

struct Test11 : InputMappable {
    let nest: Nest3
    let nests: [Nest3]
    
    init<Map>(mapper: Mapper<Map, String>) throws {
        nest = try mapper.map(from: "nest", context: .peach)
        nests = try mapper.map(from: "nests", context: .orange)
    }
}

struct Test12 : InputMappable {
    let hiddenFar: String
    
    init<Source>(mapper: Mapper<Source, String>) throws {
        self.hiddenFar = try mapper.map(from: "deeper", "stillDeeper", "close", "gotcha")
    }
}

struct Test13 : InputMappable {
    let nests: [Nest2]
    
    init<Source>(mapper: Mapper<Source, String>) throws {
        self.nests = try mapper.map()
    }
}

struct DictNest : InputMappable {
    let int: Int
    
    init<Source>(mapper: Mapper<Source, String>) throws {
        self.int = try mapper.map(from: "int")
    }
}

struct DictTest : InputMappable {
    let int: Int
    let string: String
    let double: Double
    let nest: DictNest
    let strings: [String]
    let nests: [DictNest]
    let null: Bool?
    
    init<Source>(mapper: Mapper<Source, String>) throws {
        self.int = try mapper.map(from: "int")
        self.string = try mapper.map(from: "here", "string")
        self.double = try mapper.map(from: "double")
        self.nest = try mapper.map(from: "nest")
        self.strings = try mapper.map(from: "strings")
        self.nests = try mapper.map(from: "nests")
        self.null = nil
    }
}

enum AdvancedEnum {
    case fire(rate: Int)
    case takeAim(when: TimeInterval)
    
    enum Key : String, MappingKey {
        case main
        case rate
        case timeInterval = "time-interval"
    }
}

extension AdvancedEnum: InputMappable {
    init<Source>(mapper: Mapper<Source, Key>) throws {
        let main: String = try mapper.map(from: .main)
        switch main {
        case "fire":
            let rate: Int = try mapper.map(from: .rate)
            self = .fire(rate: rate)
        case "take-aim":
            let time: TimeInterval = try mapper.map(from: .timeInterval)
            self = .takeAim(when: time)
        default:
            throw MapperError.userDefinedError
        }
    }
}

#if os(macOS)
extension InputMappable where Self : NSDate {
    public init<Source>(mapper: Mapper<Source, String>) throws {
        let interval: TimeInterval = try mapper.map()
        self.init(timeIntervalSince1970: interval)
    }
}

extension NSDate : InputMappable {
    public typealias Key = String
}
#endif

struct Test15 : InputMappable {
    let date: NSDate
    
    enum Key : String, MappingKey {
        case date
    }
    
    init<Source>(mapper: Mapper<Source, Key>) throws {
        self.date = try mapper.map(from: .date)
    }
}

public enum DateMappingContext {
    case timeIntervalSince1970
    case timeIntervalSinceReferenceDate
}

extension Date : ContextInputMappable {
    public init<Source>(mapper: ContextualMapper<Source, String, DateMappingContext>) throws {
        let interval: TimeInterval = try mapper.map()
        switch mapper.context {
        case .timeIntervalSince1970:
            self.init(timeIntervalSince1970: interval)
        case .timeIntervalSinceReferenceDate:
            self.init(timeIntervalSinceReferenceDate: interval)
        }
    }
}

class MapperTests : XCTestCase {
    func testPrimitiveMapping() throws {
        let primitiveDict: Foo = ["int": 5, "string": "String", "double": 7.8, "bool": true]
        let test = try Test1(from: primitiveDict)
        XCTAssertEqual(test.int, 5)
        XCTAssertEqual(test.string, "String")
        XCTAssertEqual(test.double, 7.8)
        XCTAssertEqual(test.bool, true)
    }
    
    func testBasicNesting() throws {
        let dict: Foo = ["string": "Rio-2016", "ints": [2, 5, 4], "nest": ["int": 11]]
        let test = try Test2(from: dict)
        XCTAssertEqual(test.string, "Rio-2016")
        XCTAssertEqual(test.ints, [2, 5, 4])
        XCTAssertEqual(test.nest.int, 11)
    }
    
    func testFailNoValue() {
        let dict: Foo = ["string": "Rio-2016"]
        XCTAssertThrowsError(try Test3(from: dict)) { error in
            guard let cError = error as? MapperError, case .valueNotFound = cError else {
                print(error)
                XCTFail("Wrong error thrown; must be .noValue")
                return
            }
        }
    }
    
    func testFailWrongType() {
        let dict: Foo = ["rio-2016": 2016]
        
        XCTAssertThrowsError(try Test3(from: dict)) { error in
            guard let error = error as? MapperError, case .wrongType = error else {
                XCTFail("Wrong error thrown; must be .wrongType")
                return
            }
        }
    }
    
    func testFailRepresentAsArray() {
        let dict: Foo = ["ints": false]
        XCTAssertThrowsError(try Test4(from: dict)) { error in
            guard let error = error as? MapperError, case .cannotRepresentAsArray = error else {
                XCTFail("Wrong error thrown; must be .cannotRepresentAsArray")
                return
            }
        }
    }
    
    func testArrayOfMappables() throws {
        let nests: [Foo] = [3, 1, 4, 6, 19].map({ .dictionary(["int": .int($0)]) })
        let dict: Foo = ["nests": .array(nests)]
        let test = try Test5(from: dict)
        XCTAssertEqual(test.nests.map({ $0.int }), [3, 1, 4, 6, 19])
    }
    
    func testEnumMapping() throws {
        let dict: Foo = ["next-big-thing": "quark", "city": 1]
        let test = try Test6(from: dict)
        XCTAssertEqual(test.string, .quark)
        XCTAssertEqual(test.int, .kharkiv)
    }
    
    func testEnumArrayMapping() throws {
        let dict: Foo = ["zewo-projects": ["venice", "annecy", "quark"], "ukraine-capitals": [1, 2]]
        let test = try Test7(from: dict)
        XCTAssertEqual(test.strings, [.venice, .annecy, .quark])
        XCTAssertEqual(test.ints, [.kharkiv, .kiev])
    }
    
    func testEnumFail() {
        let dict: Foo = ["project": "swansea"]
        XCTAssertThrowsError(try Test8(from: dict)) { error in
            guard let error = error as? MapperError, case .cannotInitializeFromRawValue = error else {
                XCTFail("Wrong error thrown; must be .cannotInitializeFromRawValue")
                return
            }
        }
    }
    
    func testBasicMappingWithContext() throws {
        let appleDict: Foo = ["apple-int": 1]
        let apple = try Nest3(from: appleDict, context: .apple)
        XCTAssertEqual(apple.int, 1)
        let peachDict: Foo = ["peach-int": 2]
        let peach = try Nest3(from: peachDict, context: .peach)
        XCTAssertEqual(peach.int, 2)
        let orangeDict: Foo = ["orange-int": 3]
        let orange = try Nest3(from: orangeDict, context: .orange)
        XCTAssertEqual(orange.int, 3)
    }
    
    func testContextInference() throws {
        let peach: Foo = ["nest": ["peach-int": 207]]
        _ = try Test9(from: peach, context: .peach)
    }
    
    func testArrayMappingWithContext() throws {
        let oranges: [Foo] = [2, 0, 1, 6].map({ .dictionary(["orange-int": $0]) })
        let dict: Foo = ["nests": .array(oranges)]
        _ = try Test10(from: dict, context: .orange)
    }
    
    func testUsingContext() throws {
        let dict: Foo = ["nest": ["peach-int": 10], "nests": [["orange-int": 15]]]
        _ = try Test11(from: dict)
    }
    
    func testDeep() throws {
        let deepDict: Foo = ["deeper": ["stillDeeper": ["close": ["gotcha": "Ukrainian Gold Medal"]]]]
        let deep = try Test12(from: deepDict)
        XCTAssertEqual(deep.hiddenFar, "Ukrainian Gold Medal")
    }
    
    func testFlatArray() throws {
        let dict: Foo = [["int": 15], ["int": 21]]
        let test = try Test13(from: dict)
        XCTAssertEqual(test.nests.map({ $0.int }), [15, 21])
    }
    
//    func testStringAnyExhaustive() throws {
//        let stringDict: [String: Any] = ["string": "Quark"]
//        let nestDict: [String: Any] = ["int": 3]
//        let nestsDictArray: [[String: Any]] = sequence(first: 1, next: { if $0 < 6 { return $0 + 1 } else { return nil } }).map({ ["int": $0] })
//        let stringsArray: [Any] = ["rope", "summit"]
//        let hugeDict: [String: Any] = [
//            "int": Int(5),
//            "here": stringDict,
//            "double": Double(8.1),
//            "nest": nestDict,
//            "strings": stringsArray,
//            "nests": nestsDictArray,
//            ]
//        let result = try DictTest(from: hugeDict)
//        print(result)
//    }
    
    func testExternalMappable() throws {
        #if os(macOS)
            let date = NSDate()
            let map: Foo = [
                "date": Foo(date.timeIntervalSince1970)
            ]
            let test = try Test15(from: map)
            XCTAssertEqual(test.date.timeIntervalSince1970, date.timeIntervalSince1970)
        #endif
    }
    
    func testDateMapping() throws {
        let dateMap = Foo(5.0)
        let date1970 = try Date(from: dateMap, context: .timeIntervalSince1970)
        XCTAssertEqual(date1970, Date(timeIntervalSince1970: 5.0))
        
        let date2001 = try Date(from: dateMap, context: .timeIntervalSinceReferenceDate)
        XCTAssertEqual(date2001, Date(timeIntervalSinceReferenceDate: 5.0))
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    struct Bar : Decodable {
        let foo: String
    }
    
    func testMapCoder() throws {
        let coder = MapCoder()
        
        let foo: Foo = ["foo": [3.0, nil]]
        
        let bar: [String: [Double?]?]? = try coder.decode(foo)
        
        print(bar)
    }
}
