//
//  XMLDoc.swift
//  XMLDoc
//
//  Created by Jinhong Kim on 9/21/16.
//  Copyright © 2016 Naver. All rights reserved.
//

import Foundation


class XMLDoc {
    // constants
    let maxDataSize: Int = 0x100000 // 1MB
    
    
    // root element
    var rootElement: XMLElement?

    
    // properties
    private var xmlDocParser: XMLDocParser?

    
    // initializer
    init(data: Data) {
        guard case 0...maxDataSize = data.count else {
            return
        }
        
        xmlDocParser = XMLDocParser(data: data)
        
        if xmlDocParser!.parse() {
            rootElement = xmlDocParser?.rootElement
        }
        
        xmlDocParser = nil
    }
}


class XMLDocParser: NSObject, XMLParserDelegate {
    let xmlParser: XMLParser
    
    var stringValue = ""
    var dataValue = Data()
    var elementStack = Stack<XMLElement>()
    var isValidValue = false
    var rootElement: XMLElement?
    
    init(data: Data) {
        xmlParser = XMLParser(data: data)
        
        super.init()
        
        xmlParser.delegate = self
    }
    
    
    func parse() -> Bool {
        return xmlParser.parse()
    }
    
    
    private func resetTemporaryValues() {
        self.stringValue = ""
        self.dataValue.removeAll()
    }
    
    
    // MARK: XMLParserDelegate
    
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if let rootElement = elementStack.top() {
            rootElement.description()
        }
    }

    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // create element
        let element = XMLElement(name: elementName, attributes: attributeDict, value: "", elements: [:], depth: elementStack.count())
        
        // push element
        elementStack.push(element: element)
        
        // reset values
        resetTemporaryValues()
        
        // set valid value flag
        isValidValue = true
    }
    
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // pop element
        guard var element = elementStack.pop() else {
            // handle error
            return
        }
        
        
        // set value
        element.setValue(stringValue: stringValue, dataValue: dataValue)

        
        // add to parent
        guard var parent = elementStack.top() else {
            // no more element
            rootElement = element
            return
        }

        parent.addElement(element: element)
        
        
        // update parent
        elementStack.replaceTop(element: parent)
        
        
        // reset values
        resetTemporaryValues()
        
        
        // set valid value flag
        isValidValue = false
    }

    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isValidValue {
            stringValue.append(string)
        }
    }


    public func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        dataValue.append(CDATABlock)
    }
    

    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
    }
    
    
    public func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        
    }
}


struct XMLElement {
    let name: String
    let attributes: Dictionary<String, String>
    var value: String
    var elements: Dictionary<String, Array<XMLElement>>
    //var elementList: Array<XMLElement>
    var elementsCount: Int {
        return self.elements.values.reduce(0) {
            $0 + $1.count
        }
    }
    
    // debug
    var depth: Int
    
    
    // MARK: set element data
    
    
    mutating func addElement(element: XMLElement) {
        var childElements = self.elements[element.name]
        
        if childElements == nil {
            childElements = Array<XMLElement>()
        }
        
        childElements?.append(element)
        self.elements[element.name] = childElements
    }
    
    
    mutating func setValue(stringValue: String, dataValue: Data) {
        if stringValue.characters.count > 0  {
            value = stringValue
        }
        else if dataValue.count > 0 {
            if let dataString = String(data: dataValue, encoding: String.Encoding.utf8) {
                value = dataString
            }
        }
        else {
            value = ""
        }
    }
    
    
    // MARK: get child element
    

    func firstElement(name: String) -> XMLElement? {
        return elements[name]?.first
    }
    
    
    func element(name: String, index: Int) -> XMLElement? {
        guard let child = elements[name], case 0..<child.count = index else {
            return nil
        }
        
        return child[index]
    }
    
    
    func elements(name: String) -> Array<XMLElement>? {
        return elements[name]
    }
    
    
    func childCount(name: String) -> Int {
        return (elements[name]?.count ?? 0)
    }
    
    
    subscript(name: String) -> Array<XMLElement>? {
        return elements[name]
    }
    
    
    subscript(name: String, index: Int) -> XMLElement? {
        return element(name: name, index: index)
    }
    
    
    // MARK: debug
    
    
    func description() {
        let emptyString = String(repeating: " ", count: depth * 2)
        
        print("\(emptyString)\(name): \(value)")
        
        for elementArray in elements.values {
            for element in elementArray {
                element.description()
            }
        }
    }
}
