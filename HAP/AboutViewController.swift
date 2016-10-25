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
        webView.backgroundColor = UIColor.clear
        webView.delegate = self
        
        if let path = Bundle.main.path(forResource: "about/\(nameOfResource)", ofType: "html"){
            if let data: Data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                let html = String(data: data, encoding: String.Encoding.utf8) ?? "En feil har oppstått."
                webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
            }
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
}
