//
//  UIColorExtension.swift
//  HAP
//
//  Created by Simen Fonnes on 06.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//
import UIKit

extension UIColor {
    convenience public init(rgba: Int64) {
        let red   = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue  = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgba & 0x000000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func makeUIColorLighter(alpha: CGFloat) -> UIColor{
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: nil){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: alpha)
        }
        return UIColor()
    }
}