//
//  LinkExtractor.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 4/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Foundation

class LinkExtractor: JSONContentExtractable {
    private let naiveLinkPattern = "https?://(?:www)?[^ ]*"
    private let simpleLinkRegex: NSRegularExpression
    
    init() {
        simpleLinkRegex = try! NSRegularExpression(pattern: naiveLinkPattern, options: .CaseInsensitive)
    }
    
    var key: String { get { return "links" } }
    
    func extractJSONContent(string: String) -> [AnyObject]? {
        var links = [[String : String]]()
        
        let results = simpleLinkRegex.matchesInString(string, options: [], range: string.nsrange)
        
        guard results.count > 0 else { return nil }
        
        for result in results {
            let link = string.substringFromNSRange(result.range)
            
            var title: String? = nil
            if let url = NSURL(string: link) {
                do {
                    let webpage = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
                    let start = webpage.rangeOfString("<title>")
                    let end = webpage.rangeOfString("</title>")
                    if start.location != NSNotFound && end.location != NSNotFound {
                        // the title starts after the title tag and the length of the title is the difference 
                        // between the start of the end title tag and the end of the start title tag
                        title = webpage.substringWithRange(NSMakeRange(start.location + start.length, end.location - (start.location + start.length)))
                    }
                }
                catch {
                    print("Could not get contents of the link.")
                }
            }
            
            var dict = [String : String]()
            dict["link"] = link
            dict["title"] = title
            links.append(dict)
        }
        
        return links
    }
}
