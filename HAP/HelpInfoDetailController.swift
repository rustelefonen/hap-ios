//
//  HelpInfoView.swift
//  HAP
//
//  Created by Simen Fonnes on 26.01.16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class HelpInfoDetailController: UIViewController, UIWebViewDelegate {
    static let storyboardId = "InfoController"
    
    @IBOutlet weak var webView: UIWebView!
    var helpInfo:HelpInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = UIColor.clearColor()
        webView.delegate = self
        
        let htmlString = "<!doctype html><html><head><link rel=\"stylesheet\" href=\"helpinfo/template.css\" type=\"text/css\"></head><body>\(helpInfo.htmlContent)</body></html>"
        webView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle().bundleURL)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType != .LinkClicked {return true}
        if request.URL?.scheme == "file" { spawnNewInfo(NSString(string: (request.URL?.lastPathComponent)!)) }
        else if request.URL != nil { UIApplication.sharedApplication().openURL(request.URL!) }
        return false
    }
    
    func spawnNewInfo(helpInfoName:NSString?) {
        if helpInfoName == nil { return }
        let helpInfoDao = HelpInfoDao()
        
        if let newHelpInfo = helpInfoDao.fetchHelpInfoByName(String(UTF8String: helpInfoName!.stringByDeletingPathExtension)!) {
            let newViewController = storyboard?.instantiateViewControllerWithIdentifier(HelpInfoDetailController.storyboardId) as! HelpInfoDetailController
            newViewController.helpInfo = newHelpInfo
            navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}