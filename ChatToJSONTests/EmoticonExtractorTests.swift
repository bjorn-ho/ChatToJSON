//
//  EmoticonExtractorTests.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 7/01/2016.
//  Copyright © 2016 Bjorn Ho. All rights reserved.
//

import Quick
import Nimble
@testable import ChatToJSON

class EmoticonExtractorTests: QuickSpec {
    var extractor = EmoticonExtractor()
    
    override func spec() {
        beforeEach {
            self.extractor = EmoticonExtractor()
        }
        
        describe("the mention extractor") {
            it("should return the correct key") {
                expect(self.extractor.key).to(match("emoticons"))
            }
            
            context("when extracting emoticons") {
                it("should return nil if there are no emoticons") {
                    let sample = "There are no emoticons in this message"
                    expect(self.extractor.extractJSONContent(sample)).to(beNil())
                }
                
                it("should return nil if there is no alphanumeric characters in parentheses") {
                    let sample = "Something something () nothing"
                    expect(self.extractor.extractJSONContent(sample)).to(beNil())
                }
                
                it("should not include an emoticon that is more than 15 characters long") {
                    let sample = "(smile) Testing out the new emoticon (supercalifragilisticexpialidocious)"
                    let emoticons = self.extractor.extractJSONContent(sample)
                    expect(emoticons!).to(haveCount(1))
                    expect((emoticons![0] as! String)).to(match("smile"))
                }
                
                it("should return one emoticon when there is one in the message") {
                    let sample = "(smile) Hey! Are you free to meet up tonight?"
                    let mentions = self.extractor.extractJSONContent(sample)
                    expect(mentions!).to(haveCount(1))
                    expect((mentions![0] as! String)).to(match("smile"))
                }
                
                it("should return a list of emoticons if there are more than one and in any order") {
                    let sample = "(shockface) All the tickets have already been sold out! (crying) Devastated."
                    let emoticons = self.extractor.extractJSONContent(sample) as! [String]
                    
                    let correctEmoticons = ["shockface", "crying"]
                    
                    expect(emoticons).to(haveCount(2))
                    
                    for (expectation, emoticon) in zip(correctEmoticons, emoticons) {
                        expect(emoticon).to(match(expectation))
                    }
                }
            }
        }
    }
}