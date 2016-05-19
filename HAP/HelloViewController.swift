//
//  HelloViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 16.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class HelloViewController: IntroContentViewController {
    static let storyboardId = "hello"
    
    var timer:NSTimer!
    
    @IBOutlet weak var swipeImgView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if timer == nil {
            view.layoutIfNeeded()
            addSwipeAnim()
            timer = NSTimer.scheduledTimerWithTimeInterval(2.01, target: self, selector: #selector(HelloViewController.addSwipeAnim), userInfo: nil, repeats: true)
        }
    }
    
    func addSwipeAnim(){
        let startX = swipeImgView.frame.origin.x + 25
        let endX = startX - 80
        
        let moveAnim = CAKeyframeAnimation(keyPath: "position.x")
        moveAnim.values = [startX, endX, endX]
        moveAnim.keyTimes = [0, 0.5, 1]
        moveAnim.duration = 1.5
        
        let fadeAnim = CAKeyframeAnimation(keyPath: "opacity")
        fadeAnim.values = [1, 0, 1]
        fadeAnim.keyTimes = [0, 0.5, 1]
        fadeAnim.duration = 1
        fadeAnim.beginTime = CACurrentMediaTime() + 1
        
        swipeImgView.layer.addAnimation(moveAnim, forKey: "position.x")
        swipeImgView.layer.addAnimation(fadeAnim, forKey: "opacity")
    }
}
