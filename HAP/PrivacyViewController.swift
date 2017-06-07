//
//  PrivacyViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 06.04.2017.
//  Copyright © 2017 Rustelefonen. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
    
    static let storyboardId = "privacySegue"
    
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func accept(_ sender: UIBarButtonItem) {
        print(parent?.parent)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}
