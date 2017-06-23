public enum XMLError : Error {
    case noContent(type: Any.Type)
    case cannotInitialize(type: Any.Type, xml: XMLElement)
    case valueNotArray(indexPath: [IndexPathComponent], xml: XMLElement)
    case outOfBounds(indexPath: [IndexPathComponent], xml: XMLElement)
    case valueNotDictionary(indexPath: [IndexPathComponent], xml: XMLElement)
    case valueNotFound(indexPath: [IndexPathComponent], xml: XMLElement)
}

extension XMLError : CustomStringConvertible {
    public var description: String {
        switch self {
        case let .noContent(type):
            return "Cannot initialize type \"\(String(describing: type))\" with no content."
        case let .cannotInitialize(type, xml):
            return "Cannot initialize type \"\(String(describing: type))\" with xml \(xml)."
        case let .valueNotArray(indexPath, content):
            return "Cannot get xml element for index path \"\(indexPath.string)\". Element is not an array \(content)."
        case let .outOfBounds(indexPath, content):
            return "Cannot get xml element for index path \"\(indexPath.string)\". Index is out of bounds for element \(content)."
        case let .valueNotDictionary(indexPath, content):
            return "Cannot get xml element for index path \"\(indexPath.string)\". Element is not a dictionary \(content)."
        case let .valueNotFound(indexPath, content):
            return "Cannot get xml element for index path \"\(indexPath.string)\". Key is not present in element \(content)."
        }
    }
}

public protocol XMLNode {
    var xmlNode: XMLNodeValue { get }
}

extension XMLElement : XMLNode {
    public var xmlNode: XMLNodeValue {
        return .element(self)
    }
}

extension String : XMLNode {
    public var xmlNode: XMLNodeValue {
        return .content(self)
    }
}

public enum XMLNodeValue {
    case element(XMLElement)
    case content(String)
}

public struct XMLElement {
    public let name: String
    public let attributes: [String: String]
    public internal(set) var children: [XMLNodeValue]
    
    public init(name: String, attributes: [String: String] = [:], children: [XMLNode] = []) {
        self.name = name
        self.attributes = attributes
        self.children = children.map({ $0.xmlNode })
    }
    
    public func getAttribute(named name: String) throws -> String {
        guard let attribute = attributes[name] else {
            throw XMLError.valueNotFound(indexPath: [.key(name)], xml: self)
        }
        
        return attribute
    }
    
    public var contents: String {
        var string = ""
        
        for child in children {
            if case let .content(content) = child {
                string += content.description
            }
        }
        
        return string
    }
    
    public func getElements(named name: String) -> [XMLElement] {
        var elements: [XMLElement] = []
        
        for element in self.elements where element.name == name {
            elements.append(element)
        }
        
        return elements
    }
    
    public var elements: [XMLElement] {
        var elements: [XMLElement] = []
        
        for child in children {
            if case let .element(element) = child {
                elements.append(element)
            }
        }
        
        return elements
    }
    
    public mutating func addElement(_ element: XMLElement) {
        children.append(.element(element))
    }
    
    public mutating func addContent(_ content: String) {
        children.append(.content(content))
    }
}

extension XMLElement : CustomStringConvertible {
    public var description: String {
        var attributes = ""

        for (offset: index, element: (key: key, value: value)) in self.attributes.enumerated() {
            if index == 0 {
                attributes += " "
            }
            
            attributes += key
            attributes += "="
            attributes += value
            
            if index < self.attributes.count - 1 {
                attributes += " "
            }
        }
        
        if !children.isEmpty {
            var string = ""
            string += "<"
            string += name
            string += attributes
            string += ">"
            
            for child in children {
                string += child.description
            }
            
            string += "</"
            string += name
            string += ">"
            return string
        }
        
        guard !contents.isEmpty else {
            return "<\(name)\(attributes)/>"
            
        }
        
        return "<\(name)\(attributes)>\(contents)</\(name)>"
    }
}

extension XMLNodeValue : CustomStringConvertible {
    public var description: String {
        switch self {
        case let .element(element):
            return element.description
        case let .content(content):
            return content
        }
    }
}
