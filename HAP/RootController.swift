//
//  RootController.swift
//  HAP
//
//  Created by Fredrik Loberg on 09/05/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class RootController: UIViewController{
    
    //no animation of first appearance
    var firstAppearance = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let user = AppDelegate.getUserInfo()
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier(user != nil ? MainTabBarController.storyboardId : IntroPageViewController.storyboardId){
            presentViewController(vc, animated: !firstAppearance, completion: nil)
            firstAppearance = false
        }
    }
}
