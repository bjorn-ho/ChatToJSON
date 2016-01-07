//
//  LinkExtractor.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 7/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Quick
import Nimble
@testable import ChatToJSON

class LinkExtractorTests: QuickSpec {
    var extractor = LinkExtractor()
    
    override func spec() {
        beforeEach {
            self.extractor = LinkExtractor()
        }
        
        describe("the mention extractor") {
            it("should return the correct key") {
                expect(self.extractor.key).to(match("links"))
            }
            
            // Only test out the link since the webpage title can change at anytime, not really suitable
            // as a unit test
            context("when extracting links") {
                it("should return nil if there are no links") {
                    let sample = "There are no links in this message"
                    expect(self.extractor.extractJSONContent(sample)).to(beNil())
                }
                
                it("should return one link when there is one in the message") {
                    let sample = "Try this site out https://www.twitter.com"
                    let links = self.extractor.extractJSONContent(sample) as! [[String : String]]
                    expect(links).to(haveCount(1))
                    
                    let linkDic = links[0]
                    expect(linkDic["link"]).to(match("https://www.twitter.com"))
                }
                
                it("should return a list of links if there are more than one and in any order") {
                    let sample = "You should check these guys out https://www.natashatherobot.com http://airspeedvelocity.net All the Swift things!"
                    let links = self.extractor.extractJSONContent(sample) as! [[String : String]]
                    
                    let correctLinks = ["https://www.natashatherobot.com", "http://airspeedvelocity.net"]
                    
                    expect(links).to(haveCount(2))
                    
                    for (expectation, link) in zip(correctLinks, links.map { $0["link"] }) {
                        expect(link).to(match(expectation))
                    }
                }
            }
        }
    }
}
