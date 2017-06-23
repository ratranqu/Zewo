import XCTest
@testable import Media
import Foundation

public class XMLTests: XCTestCase {
    func testXML() throws {
        let xml = XMLElement(name: "Root", children: [
            XMLElement(name: "Catalog", children: [
                XMLElement(name: "Book", attributes: ["id": "a"], children: [
                    XMLElement(name: "Author", children: ["Bob"]),
                ]),
                XMLElement(name: "Book", attributes: ["id": "b"], children: [
                    XMLElement(name: "Author", children: ["John"]),
                ]),
                XMLElement(name: "Book", attributes: ["id": "c"], children: [
                    XMLElement(name: "Author", children: ["Mark"]),
                ]),
            ]),
        ])
        
        try print(xml.get("Catalog", "Book", 1, "Author").contents)
        try print(xml.get("Catalog", 0, "Book", 1, "Author", 0).contents)
        try print(xml.get("Catalog", "Book", 1).getAttribute("id") ?? "nope")
        try print(xml.get("Catalog", "Book").withAttribute("id", equalTo: "b")?.get("Author").contents ?? "nope")
        
        for element in try xml.get("Catalog", "Book") {
            try print(element.get("Author").contents)
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
