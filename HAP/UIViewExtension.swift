//
//  UIViewExtension.swift
//  HAP
//
//  Created by Simen Fonnes on 06.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

extension UIView {
    func endEditingInFirstResponder() -> UIView?{
        if isFirstResponder(){
            endEditing(true)
            return self
        }
        
        for subview in subviews {
            if subview.isFirstResponder() {
                subview.endEditing(true)
                return subview
            }
            subview.endEditingInFirstResponder()
        }
        return nil
    }
}