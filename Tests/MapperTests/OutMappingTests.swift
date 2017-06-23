import XCTest
import Foundation
@testable import Mapper

extension Test1 : OutputMappable {
    func map<Map>(mapper: inout Mapper<Map, Key>) throws {
        try mapper.map(int, to: .int)
        try mapper.map(double, to: .double)
        try mapper.map(string, to: .string)
        try mapper.map(bool, to: .bool)
    }
}

extension Nest2 : OutputMappable {
    func map<Map>(mapper: inout Mapper<Map, Key>) throws {
        try mapper.map(int, to: .int)
    }
}

extension Test2 : OutputMappable {
    func map<Map>(mapper: inout Mapper<Map, Key>) throws {
        try mapper.map(string, to: .string)
        try mapper.map(ints, to: .ints)
        try mapper.map(nest, to: .nest)
    }
}

struct Test14 : OutputMappable {
    let array: [Int]
    
    func map<Map>(mapper: inout Mapper<Map, String>) throws {
        try mapper.map(array, to: "array")
    }
}

extension Test5 : OutputMappable {
    func map<Map>(mapper: inout Mapper<Map, Key>) throws {
        try mapper.map(nests, to: .nests)
    }
}

//extension Test6 : OutMappable {
//    func outMap<Map>(mapper: inout OutMapper<Map, Key>) throws {
//        try mapper.map(self.string, to: .string)
//        try mapper.map(self.int, to: .int)
//    }
//}
//
//extension Test7 : OutMappable {
//    func outMap<Map>(mapper: inout OutMapper<Map, Key>) throws {
//        try mapper.map(self.strings, to: .strings)
//        try mapper.map(self.ints, to: .ints)
//    }
//}

extension Nest3 : ContextOutputMappable {
    func outMap<Map>(mapper: inout ContextualMapper<Map, String, TestContext>) throws {
        switch mapper.context {
        case .apple:
            try mapper.map(self.int, to: "apple-int")
        case .peach:
            try mapper.map(self.int, to: "peach-int")
        case .orange:
            try mapper.map(self.int, to: "orange-int")
        }
    }
}

extension Test9 : ContextOutputMappable {
    func outMap<Map>(mapper: inout ContextualMapper<Map, String, TestContext>) throws {
        try mapper.map(self.nest, to: "nest")
    }
}

extension Test10 : ContextOutputMappable {
    func outMap<Map>(mapper: inout ContextualMapper<Map, String, TestContext>) throws {
        try mapper.map(nests, to: "nests")
    }
}

extension Test11 : OutputMappable {
    func map<Map>(mapper: inout Mapper<Map, String>) throws {
        try mapper.map(nest, to: "nest", context: .peach)
        try mapper.map(nests, to: "nests", context: .orange)
    }
}

struct OutDictNest : OutputMappable {
    let int: Int
    
    func map<Map>(mapper: inout Mapper<Map, String>) throws {
        try mapper.map(int, to: "int")
    }
}

struct OutDictTest : OutputMappable {
    let int: Int
    let string: String
    let nest: OutDictNest
    let strings: [String]
    let nests: [OutDictNest]
    
    func map<Map>(mapper: inout Mapper<Map, String>) throws {
        try mapper.map(int, to: "int")
        try mapper.map(string, to: "string")
        try mapper.map(nest, to: "nest")
        try mapper.map(strings, to: "strings")
        try mapper.map(nests, to: "nests")
    }
}

#if os(macOS)
    extension OutputMappable where Self : NSDate {
        public func map<Map>(mapper: inout Mapper<Map, String>) throws {
            try mapper.map(timeIntervalSince1970)
        }
    }
    
    extension NSDate : OutputMappable {}
    
    extension Test15 : OutputMappable {
        func map<Map>(mapper: inout Mapper<Map, Key>) throws {
            try mapper.map(date, to: .date)
        }
    }
#endif

extension Date : ContextOutputMappable {
    public func outMap<Map>(mapper: inout ContextualMapper<Map, String, DateMappingContext>) throws {
        switch mapper.context {
        case .timeIntervalSince1970:
            try mapper.map(timeIntervalSince1970)
        case .timeIntervalSinceReferenceDate:
            try mapper.map(timeIntervalSinceReferenceDate)
        }
    }
}

class OutMapperTests: XCTestCase {
    func testPrimitiveTypesMapping() throws {
        let map: Foo = ["int": 15, "double": 32.0, "string": "Hello", "bool": true]
        let test = try Test1(from: map)
        let unmap: Foo = try test.map()
        XCTAssertEqual(map, unmap)
    }
    
    func testBasicNesting() throws {
        let dict: Foo = ["string": "Rio-2016", "ints": [2, 5, 4], "nest": ["int": 11]]
        let test = try Test2(from: dict)
        let back: Foo = try test.map()
        XCTAssertEqual(dict, back)
    }
    
    func testArrayOfMappables() throws {
        let nests: [Foo] = [3, 1, 4, 6, 19].map({ .dictionary(["int": .int($0)]) })
        let dict: Foo = ["nests": .array(nests)]
        let test = try Test5(from: dict)
        let back: Foo = try test.map()
        XCTAssertEqual(dict, back)
    }
    
//    func testEnumMappng() throws {
//        let dict: Foo = ["next-big-thing": "quark", "city": 1]
//        let test = try Test6(from: dict)
//        let back: Foo = try test.map()
//        XCTAssertEqual(dict, back)
//    }
//
//    func testEnumArrayMapping() throws {
//        let dict: Foo = ["zewo-projects": ["venice", "annecy", "quark"], "ukraine-capitals": [1, 2]]
//        let test = try Test7(from: dict)
//        let back: Foo = try test.map()
//        XCTAssertEqual(dict, back)
//    }
    
    func testBasicMappingWithContext() throws {
        let appleDict: Foo = ["apple-int": 1]
        let apple = try Nest3(from: appleDict, context: .apple)
        XCTAssertEqual(appleDict, try apple.map(context: .apple))
        let peachDict: Foo = ["peach-int": 2]
        let peach = try Nest3(from: peachDict, context: .peach)
        XCTAssertEqual(peachDict, try peach.map(context: .peach))
        let orangeDict: Foo = ["orange-int": 3]
        let orange = try Nest3(from: orangeDict, context: .orange)
        XCTAssertEqual(orangeDict, try orange.map(context: .orange))
    }
    
    func testContextInference() throws {
        let peachDict: Foo = ["nest": ["peach-int": 207]]
        let peach = try Test9(from: peachDict, context: .peach)
        XCTAssertEqual(peachDict, try peach.map(context: .peach))
    }
    
    func testArrayMappingWithContext() throws {
        let orangesDict: [Foo] = [2, 0, 1, 6].map({ .dictionary(["orange-int": $0]) })
        let dict: Foo = ["nests": .array(orangesDict)]
        let oranges = try Test10(from: dict, context: .orange)
        let back: Foo = try oranges.map(context: .orange)
        XCTAssertEqual(dict, back)
    }
    
    func testUsingContext() throws {
        let dict: Foo = ["nest": ["peach-int": 10], "nests": [["orange-int": 15]]]
        let test = try Test11(from: dict)
        XCTAssertEqual(dict, try test.map())
    }
    
    func testExternalMappable() throws {
        #if os(macOS)
            let date = NSDate()
            
            let dict: Foo = [
                "date": Foo(date.timeIntervalSince1970)
            ]
            
            let test = try Test15(from: dict)
            let back: Foo = try test.map()
            let backDate: TimeInterval = back["date"].double!
            XCTAssertEqual(date.timeIntervalSince1970, backDate)
        #endif
    }
    
    func testDateMapping() throws {
        let date1970 = Date.init(timeIntervalSince1970: 5.0)
        let date1970Map: Foo = try date1970.map(context: .timeIntervalSince1970)
        XCTAssertEqual(date1970Map.double!, 5.0)
        
        let date2001 = Date.init(timeIntervalSinceReferenceDate: 5.0)
        let date2001Map: Foo = try date2001.map(context: .timeIntervalSinceReferenceDate)
        XCTAssertEqual(date2001Map.double!, 5.0)
    }
    
//    func testStringAnyExhaustive() throws {
//        // expected
//        let nestDict: [String: Any] = ["int": 3]
//        let nestsDictArray: [[String: Any]] = sequence(first: 1, next: { if $0 < 6 { return $0 + 1 } else { return nil } }).map({ ["int": $0] })
//        let stringsArray: [Any] = ["rope", "summit"]
//        let hugeDict: [String: Any] = [
//            "int": Int(5),
//            "string": "Quark",
//            "nest": nestDict,
//            "strings": stringsArray,
//            "nests": nestsDictArray,
//            ]
//        //
//        let nest = OutDictNest(int: 3)
//        let nests = sequence(first: 1, next: { if $0 < 6 { return $0 + 1 } else { return nil } }).map({ OutDictNest(int: $0) })
//        let test = OutDictTest(int: 5, string: "Quark", nest: nest, strings: ["rope", "summit"], nests: nests)
//        let back = try test.map() as [String: Any]
//        XCTAssertEqual(back as NSDictionary, hugeDict as NSDictionary)
//    }
    
}
