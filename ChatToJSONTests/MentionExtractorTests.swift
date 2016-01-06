//
//  MentionExtractorTests.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 6/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Quick
import Nimble
@testable import ChatToJSON

class MentionExtractorTests: QuickSpec {
    var extractor = MentionExtractor()
    
    override func spec() {
        beforeEach {
            self.extractor = MentionExtractor()
        }
        
        describe("the mention extractor") {
            it("should return the correct key") {
                expect(self.extractor.key).to(match("mentions"))
            }
            
            context("when extracting mentions") {
                it("should return nil if there are no mentions") {
                    let sample = "There are no mentions in this message"
                    expect(self.extractor.extractJSONContent(sample)).to(beNil())
                }
                
                it("should return one mention when there is one in the message") {
                    let sample = "@nrg84 Hey! Are you free to meet up tonight?"
                    let mentions = self.extractor.extractJSONContent(sample) as! [String]
                    expect(mentions).to(haveCount(1))
                    expect(mentions[0]).to(match("nrg84"))
                }
                
                it("should return a list of mentions if there are more than one and in any order") {
                    let sample = "@nrg84 Can you ask @_witherow88 whether he is coming to the party tonight?"
                    let mentions = self.extractor.extractJSONContent(sample) as! [String]
                    
                    let correctMentions = ["nrg84", "_witherow88"]
                    
                    expect(mentions).to(haveCount(2))
                    
                    for (expectation, mention) in zip(correctMentions, mentions) {
                        expect(mention).to(match(expectation))
                    }
                }
            }
        }
    }
}