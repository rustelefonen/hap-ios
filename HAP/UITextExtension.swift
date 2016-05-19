//
//  UITextViewExtension.swift
//  HAP
//
//  Created by Fredrik Loberg on 08/05/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

extension UILabel{
    
    func updateText(text:String?) {
        if self.text == text { return }
        self.text = text
    }
}

extension UITextView{
    
    func updateText(text:String?) {
        if self.text == text { return }
        self.text = text
    }
}