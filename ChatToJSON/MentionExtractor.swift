//
//  MentionExtractor.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 4/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Foundation

class MentionExtractor: JSONContentExtractable {
    private let mentionPattern = "@(\\w+)\\b"
    private let mentionRegex: NSRegularExpression
    
    init() {
        mentionRegex = try! NSRegularExpression(pattern: mentionPattern, options: .CaseInsensitive)
    }
    
    var key: String { get { return "mentions" } }
    
    func extractJSONContent(string: String) -> [AnyObject]? {
        var mentions = [String]()
        
        // Find all mentions based on the regex pattern
        let results = mentionRegex.matchesInString(string, options: [], range: string.nsrange)
        
        guard results.count > 0 else { return nil }
        
        // strip out the @ sign before adding to the list
        for result in results {
            mentions.append(string.substringFromNSRange(result.rangeAtIndex(1)))
        }
        
        return mentions
    }
}