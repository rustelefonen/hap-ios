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
        webView.backgroundColor = UIColor.clear
        webView.delegate = self
        
        let htmlString = "<!doctype html><html><head><link rel=\"stylesheet\" href=\"helpinfo/template.css\" type=\"text/css\"></head><body>\(helpInfo.htmlContent)</body></html>"
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType != .linkClicked {return true}
        if request.url?.scheme == "file" { spawnNewInfo(NSString(string: (request.url?.lastPathComponent)!)) }
        else if request.url != nil { UIApplication.shared.openURL(request.url!) }
        return false
    }
    
    func spawnNewInfo(_ helpInfoName:NSString?) {
        if helpInfoName == nil { return }
        let helpInfoDao = HelpInfoDao()
        
        if let newHelpInfo = helpInfoDao.fetchHelpInfoByName(String(validatingUTF8: helpInfoName!.deletingPathExtension)!) {
            let newViewController = storyboard?.instantiateViewController(withIdentifier: HelpInfoDetailController.storyboardId) as! HelpInfoDetailController
            newViewController.helpInfo = newHelpInfo
            navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}
