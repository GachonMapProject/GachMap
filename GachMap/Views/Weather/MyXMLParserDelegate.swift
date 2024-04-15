//
//  MyXMLParserDelegate.swift
//  GachMap
//
//  Created by 이수현 on 4/15/24.
//


import Foundation
class MyXMLParserDelegate: NSObject, XMLParserDelegate{
    var currentElement = ""
    var key = ""
    var items: [String : String] = [:]
    
    var completionHandler: (([String: String]) -> Void)?

    init(completion: (([String: String]) -> Void)?) {
        self.completionHandler = completion
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "category"{
            currentElement = "category"
        } else if elementName == "fcstValue"{
            currentElement = "fcstValue"
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "category" &&  (string == "TMP" || string == "SKY" || string == "PTY" || string == "RN1") { // 원하는 태그명을 지정하여 해당 태그의 값을 추출할 수 있습니다.
            key = string
        } else if currentElement == "fcstValue" && key != ""{
            items[key] = string
            key = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("parserDidEndDocument : \(items)")
        completionHandler!(items)
    }
}
