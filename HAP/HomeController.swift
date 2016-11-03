//
//  HomeController.swift
//  HAP
//
//  Created by Simen Fonnes on 26.01.16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    
    //Fields
    var userInfo : UserInfo!
    @IBInspectable var beforeStartClock:String!
    @IBInspectable var afterStartClock:String!
    @IBInspectable var startCalculator:String!
    @IBInspectable var calculatorLabel:String!
    
    //Outlets
    @IBOutlet weak var clockView: UIClockView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var moneySavedLabel: UILabel!
    
    let formatter = NumberFormatter()
    var updateTimer:Timer!
    
    override func viewDidLoad() {
        userInfo = AppDelegate.getUserInfo()
        initFormatter()
        updateDailySubject()
        moneySavedLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCalculator)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(updateTimer, forMode: RunLoopMode.commonModes)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateTimer.invalidate()
    }
    
    func update() {
        updateClockTimer()
        updateCalculator()
        updateDailySubject()
    }
    
    fileprivate func updateClockTimer(){
        let counter = userInfo.timeInSecondsSinceStarted()
        clockView.updateClock(abs(counter))
        header.updateText(counter < 0 ? beforeStartClock : afterStartClock)
    }
    
    fileprivate func updateCalculator(){
        if userInfo.totalMoneySaved() > 0.0 { moneySavedLabel.updateText("\(calculatorLabel!) \(getFormattedCurrencyString()) kr.") }
        else { moneySavedLabel.updateText(startCalculator) }
    }
    
    func updateDailySubject() {
        var index = userInfo.daysSinceStarted()
        if index >= ResourceList.dailyThemes.count { index = ResourceList.dailyThemes.count - 1 }
        else if index < 0 { index = 0 }
        
        if ResourceList.dailyThemes.count > 0 { contentTextView.updateText(ResourceList.dailyThemes[index]) }
        else {contentTextView.updateText("Wow, ingen daglige temaer tilgjengelige") }
    }
    
    @IBAction func settingsAction(_ sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    func showCalculator(){
        performSegue(withIdentifier: "calculatorSegue", sender: self)
    }
    
    fileprivate func getFormattedCurrencyString() -> String{
        return formatter.string(from: NSNumber(value: userInfo.totalMoneySaved())) ?? "0"
    }
    
    fileprivate func initFormatter(){
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = " "
    }
}
