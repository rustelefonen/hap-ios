//
//  KekKekController.swift
//  HAP
//
//  Created by Simen Fonnes on 08.04.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class QuestionController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBInspectable var placeHolderText: String!
    
    var questionLabel:UILabel!
    var defaultTextColor:UIColor!
    
    override func viewDidLoad() {
        textView.delegate = self
        defaultTextColor = textView.textColor
        
        if questionLabel.text!.characters.count > 0 { textView.text = questionLabel.text }
        else { setPlaceholderText() }
    }
    
    private func setPlaceholderText(){
        textView.text = placeHolderText
        textView.textColor = UIColor.lightGrayColor()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text! == placeHolderText {
            performSelector(#selector(moveCaretToStart), withObject: self, afterDelay: 0.01)
        }
        textView.contentInset = UIEdgeInsetsMake(0, 0, 130, 0)
    }
    
    func moveCaretToStart(){
        textView.selectedRange = NSMakeRange(0, 0)
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if textView.text! == placeHolderText { moveCaretToStart() }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text! == "") { setPlaceholderText() }
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        removePlaceholderTextIfPresent()
        return !insertedPlaceholderTextIfEmpty(textView, shouldChangeTextInRange: range, replacementText: text)
    }
    
    private func removePlaceholderTextIfPresent(){
        if textView.text! == placeHolderText {
            textView.text = ""
            textView.textColor = defaultTextColor
        }
    }
    
    private func insertedPlaceholderTextIfEmpty(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            let theText = NSString(string: textView.text).stringByReplacingCharactersInRange(range, withString: "")
            if theText.characters.count == 0 {
                textView.text = ""
                textViewDidEndEditing(textView)
                return true
            }
        }
        return false
    }
    
    @IBAction func finishedAction(sender: AnyObject) {
        if textView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "Skriv ditt spørsmål her.." {
            questionLabel.text = textView.text
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}