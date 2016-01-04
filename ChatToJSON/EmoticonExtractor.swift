//
//  EmojiExtractor.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 4/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Foundation

class EmoticonExtractor: JSONContentExtractable {
    private let emoticonPattern = "\\((\\w{1,15})\\)"
    private let emoticonRegex: NSRegularExpression
    
    init() {
        emoticonRegex = try! NSRegularExpression(pattern: emoticonPattern, options: .CaseInsensitive)
    }
    
    var key: String { get { return "emoticons" } }
    
    func extractJSONContent(string: String) -> [AnyObject]? {
        var emoticons = [String]()
        
        let results = emoticonRegex.matchesInString(string, options: [], range: string.nsrange)
        
        guard results.count > 0 else { return nil }
        
        for result in results {
            emoticons.append(string.substringFromNSRange(result.rangeAtIndex(1)))
        }
        
        return emoticons
    }
}
