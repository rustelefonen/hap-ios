//
//  UIHole.swift
//  HAP
//
//  Created by Simen Fonnes on 05.04.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class UIOverlay: UIView {

    class func spawnDefault() -> UIOverlay{
        let overlay = UIOverlay(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        overlay.backgroundColor = UIColor.blackColor()
        overlay.userInteractionEnabled = true
        overlay.alpha = 0.5
        
        let arrow = UIImageView(frame: CGRect(x: overlay.frame.width - 160, y: 10, width: 150, height: 150))
        arrow.image = UIImage(named: "TriggerdagbokTutorial")
        arrow.contentMode = UIViewContentMode.ScaleAspectFit
        overlay.addSubview(arrow)
        
        UIApplication.sharedApplication().keyWindow!.addSubview(overlay)
        overlay.addGestureRecognizer(UITapGestureRecognizer(target: overlay, action: #selector(despawn)))
        
        return overlay
    }
    
    func despawn() {
        if superview != nil {
            removeFromSuperview()
        }
    }
    
    class func despawnAllOverlays(){
        for subview in UIApplication.sharedApplication().keyWindow?.subviews ?? [] {
            if subview is UIOverlay { subview.removeFromSuperview() }
        }
    }
}