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
        let overlay = UIOverlay(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        overlay.backgroundColor = UIColor.black
        overlay.isUserInteractionEnabled = true
        overlay.alpha = 0.5
        
        let arrow = UIImageView(frame: CGRect(x: overlay.frame.width - 160, y: 10, width: 150, height: 150))
        arrow.image = UIImage(named: "TriggerdagbokTutorial")
        arrow.contentMode = UIViewContentMode.scaleAspectFit
        overlay.addSubview(arrow)
        
        UIApplication.shared.keyWindow!.addSubview(overlay)
        overlay.addGestureRecognizer(UITapGestureRecognizer(target: overlay, action: #selector(despawn)))
        
        return overlay
    }
    
    func despawn() {
        if superview != nil {
            removeFromSuperview()
        }
    }
    
    class func despawnAllOverlays(){
        for subview in UIApplication.shared.keyWindow?.subviews ?? [] {
            if subview is UIOverlay { subview.removeFromSuperview() }
        }
    }
}
