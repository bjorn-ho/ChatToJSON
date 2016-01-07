//
//  ChatMessageParserTests.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 7/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Quick
import Nimble
@testable import ChatToJSON

class ChatMessageParserTests: QuickSpec {
    override func spec() {
        describe("the chat message parser") {
            it("has 3 feature content extractors") {
                let parser = ChatMessageParser()
                expect(parser.contentExtractors).to(haveCount(3))
            }
        }
        
        context("when parsing chat messages") {
            it("should build a diction with all the special content in the message") {
                let parser = ChatMessageParser()
                let message = "@leia Help me @obiwan, you're my only hope (begging) http://deathstarplans.com"
                let content = parser.buildJSONDictionary(message)
                
                // Got to test for each individual content
                expect(content["mentions"]).toNot(beNil())
                let mentions = content["mentions"] as! [String]
                expect(mentions).to(equal(["leia", "obiwan"]))
                
                expect(content["emoticons"]).toNot(beNil())
                let emoticons = content["emoticons"] as! [String]
                expect(emoticons).to(equal(["begging"]))
                
                expect(content["links"]).toNot(beNil())
                let links = content["links"] as! [[String : String]]
                expect(links).to(equal([["url":"http://deathstarplans.com", "title":"DeathStarPlans.com"]]))
            }
        }
    }
}
