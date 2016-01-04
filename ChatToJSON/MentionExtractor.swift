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
        
        let results = mentionRegex.matchesInString(string, options: [], range: string.nsrange)
        
        guard results.count > 0 else { return nil }
        
        for result in results {
            mentions.append(string.substringFromNSRange(result.rangeAtIndex(1)))
        }
        
        return mentions
    }
}