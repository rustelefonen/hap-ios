//
//  RootController.swift
//  HAP
//
//  Created by Fredrik Loberg on 09/05/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

class RootController: UIViewController{
    
    //no animation of first appearance
    var firstAppearance = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let user = AppDelegate.getUserInfo()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: user != nil ? MainTabBarController.storyboardId : IntroPageViewController.storyboardId){
            present(vc, animated: !firstAppearance, completion: nil)
            firstAppearance = false
        }
    }
}
