//
//  ViewController.swift
//  ChatToJSON
//
//  Created by Bjorn Ho on 15/12/2015.
//  Copyright © 2015 Bjorn Ho. All rights reserved.
//

import UIKit

class ChatToJSONViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var generateJSONButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    let chatParser = ChatMessageParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "Type chat message here"
    }

    @IBAction func buttonPressed(sender: UIButton) {
        if let specialContent = chatParser.parseContent(textView.text) {
            contentTextView.text = specialContent
        }
    }
}


