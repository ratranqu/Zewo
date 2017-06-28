import XCTest
@testable import Media
import Foundation

struct Book : Decodable {
    let author: String
    
    enum Key : String, CodingKey {
        case author = "Author"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        author = try container.decode(String.self, forKey: .author)
    }
}

struct Catalog : Decodable {
    let books: [Book]
    
    enum Key : String, CodingKey {
        case book = "Book"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.books = try container.decode([Book].self, forKey: .book)
    }
}

struct Root : Decodable {
    let catalog: Catalog
    
    enum Key : String, CodingKey {
        case catalog = "Catalog"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        catalog = try container.decode(Catalog.self, forKey: .catalog)
    }
}

public class XMLTests: XCTestCase {
    func testXML() throws {
        do {
            let xml = XML(root:
                XML.Element(name: "Catalog", children: [
                    XML.Element(name: "Book", attributes: ["id": "a"], children: [
                        XML.Element(name: "Author", children: ["Bob"]),
                    ]),
                    XML.Element(name: "Book", attributes: ["id": "b"], children: [
                        XML.Element(name: "Author", children: ["John"]),
                    ]),
                    XML.Element(name: "Book", attributes: ["id": "c"], children: [
                        XML.Element(name: "Author", children: ["Mark"]),
                    ]),
                ])
            )
            
            let json: JSON = [
                "Catalog": [
                    "Book": [
                        ["Author": "Bob"],
                        ["Author": "John"],
                        ["Author": "Mark"],
                    ]
                ]
            ]
            
            var root: Root
            
            root = try Root(from: json)
            print(root)
            
            root = try Root(from: xml)
            print(root)
        } catch {
            print(error)
        }
    }
}

extension XMLTests {
    public static var allTests: [(String, (XMLTests) -> () throws -> Void)] {
        return [
            ("testXML", testXML),
        ]
    }
}
