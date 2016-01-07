//
//  ChatMessageParser.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 4/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Foundation

/** A protocol that can provide a key and value to be used in a JSON representation */
protocol JSONContentExtractable {
    /** The key of this JSON entry */
    var key: String { get }
    
    /** The value of this JSON entry */
    func extractJSONContent(string: String) -> [AnyObject]?
}

class ChatMessageParser {
    /** A list of objects adopting the `JSONContentExtractable` protocol that can look for specific content given a string input */
    var contentExtractors: [JSONContentExtractable] = [JSONContentExtractable]()
    
    init() {
        contentExtractors.append(MentionExtractor())
        contentExtractors.append(EmoticonExtractor())
        contentExtractors.append(LinkExtractor())
    }
    
    /** 
     Method to parse a string for special content that we are interested to be represented in JSON format
     - parameter message: An input string that may contain some special content
     - return: A string in JSON format of all the special content formed from the input
    */
    func parseContent(message: String) -> String? {
        // First construct a dictionary representing the JSON content of all the special
        // content that we are interested
        let json = buildJSONDictionary(message)
        
        // Convert the JSON dictionary into a string to be passed back to be displayed
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
                // sanitise the output since the slashes could be escaped
                return jsonString.stringByReplacingOccurrencesOfString("\\/", withString: "/")
            }
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
    /** Computed property to return an `NSRange` */
    var nsrange: NSRange { get { return NSMakeRange(0, characters.count) } }
    
    /** Method to get a substring from an `NSRange` instead of the Swift `Range` struct */
    func substringFromNSRange(range: NSRange) -> String {
        let a  = Range(start: startIndex.advancedBy(range.location), end: startIndex.advancedBy(range.location + range.length))
        return substringWithRange(a)
    }
}