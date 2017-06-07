//
//  QuestionViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 07.06.2017.
//  Copyright © 2017 Rustelefonen. All rights reserved.
//

import UIKit

class SurveyController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if url != nil {
            webView.loadRequest(URLRequest(url: URL(string: url!)!))
        }
    }
}
