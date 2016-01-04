//
//  ChatMessageParser.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 4/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Foundation

protocol JSONContentExtractable {
    var key: String { get }
    
    func extractJSONContent(string: String) -> [AnyObject]?
}

class ChatMessageParser {
    var contentExtractors: [JSONContentExtractable] = [JSONContentExtractable]()
    
    init() {
        contentExtractors.append(MentionExtractor())
        contentExtractors.append(EmoticonExtractor())
    }
    
    func parseContent(message: String) -> String? {
        let json = buildJSONDictionary(message)
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            return NSString(data: jsonData, encoding: NSUTF8StringEncoding) as? String
        }
        catch {
            fatalError("Error: \(error)")
        }
        
        return nil
    }
    
    func buildJSONDictionary(message: String) -> [String : AnyObject] {
        var json = [String : AnyObject]()
        for contentExtractor in contentExtractors {
            if let content = contentExtractor.extractJSONContent(message) {
                json[contentExtractor.key] = content
            }
        }
        return json
    }
}

extension String {
    var nsrange: NSRange { get { return NSMakeRange(0, characters.count) } }
    
    func substringFromNSRange(range: NSRange) -> String {
        let a  = Range(start: startIndex.advancedBy(range.location), end: startIndex.advancedBy(range.location + range.length))
        return substringWithRange(a)
    }
}