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
    
    static let segueId = "surveySegue"
    
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        if url != nil {
            webView.loadRequest(URLRequest(url: URL(string: url!)!))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingToParentViewController {
            print("moving!")
        }
    }
    @IBAction func finishedSurvey(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Er du sikker på at du vil gå tilbake?", message: "Hvis du går tilbake uten å ha fullført undersøkelsen, vil du ikke kunne svare på denne undersøkelsen igjen.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Bli værende", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Gå tilbake", style: UIAlertActionStyle.destructive, handler: { action in            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
