//
//  AboutViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 23.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
    static let storyboardId = "about"
    
    @IBOutlet weak var webView: UIWebView!
    let nameOfResource = "OmApp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = UIColor.clearColor()
        webView.delegate = self
        
        if let path = NSBundle.mainBundle().pathForResource("about/\(nameOfResource)", ofType: "html"){
            if let data: NSData = NSData(contentsOfFile:path){
                let html = String(data: data, encoding: NSUTF8StringEncoding) ?? "En feil har oppstått."
                webView.loadHTMLString(html, baseURL: NSBundle.mainBundle().bundleURL)
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}