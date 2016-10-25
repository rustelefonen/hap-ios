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
    
    fileprivate func setPlaceholderText(){
        textView.text = placeHolderText
        textView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text! == placeHolderText {
            perform(#selector(moveCaretToStart), with: self, afterDelay: 0.01)
        }
        textView.contentInset = UIEdgeInsetsMake(0, 0, 130, 0)
    }
    
    func moveCaretToStart(){
        textView.selectedRange = NSMakeRange(0, 0)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text! == placeHolderText { moveCaretToStart() }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text! == "") { setPlaceholderText() }
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        removePlaceholderTextIfPresent()
        return !insertedPlaceholderTextIfEmpty(textView, shouldChangeTextInRange: range, replacementText: text)
    }
    
    fileprivate func removePlaceholderTextIfPresent(){
        if textView.text! == placeHolderText {
            textView.text = ""
            textView.textColor = defaultTextColor
        }
    }
    
    fileprivate func insertedPlaceholderTextIfEmpty(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            let theText = NSString(string: textView.text).replacingCharacters(in: range, with: "")
            if theText.characters.count == 0 {
                textView.text = ""
                textViewDidEndEditing(textView)
                return true
            }
        }
        return false
    }
    
    @IBAction func finishedAction(_ sender: AnyObject) {
        if textView.text.trimmingCharacters(in: CharacterSet.whitespaces) != "Skriv ditt spørsmål her.." {
            questionLabel.text = textView.text
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}
