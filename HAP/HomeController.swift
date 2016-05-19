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
    
    let formatter = NSNumberFormatter()
    var updateTimer:NSTimer!
    
    override func viewDidLoad() {
        userInfo = AppDelegate.getUserInfo()
        initFormatter()
        updateDailySubject()
        moneySavedLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCalculator)))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        update()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(updateTimer, forMode: NSRunLoopCommonModes)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        updateTimer.invalidate()
    }
    
    func update() {
        updateClockTimer()
        updateCalculator()
        updateDailySubject()
    }
    
    private func updateClockTimer(){
        let counter = userInfo.timeInSecondsSinceStarted()
        clockView.updateClock(abs(counter))
        header.updateText(counter < 0 ? beforeStartClock : afterStartClock)
    }
    
    private func updateCalculator(){
        if userInfo.totalMoneySaved() > 0.0 { moneySavedLabel.updateText("\(calculatorLabel) \(getFormattedCurrencyString()) kr.") }
        else { moneySavedLabel.updateText(startCalculator) }
    }
    
    func updateDailySubject() {
        var index = userInfo.daysSinceStarted()
        if index >= ResourceList.dailyThemes.count { index = ResourceList.dailyThemes.count - 1 }
        else if index < 0 { index = 0 }
        
        if ResourceList.dailyThemes.count > 0 { contentTextView.updateText(ResourceList.dailyThemes[index]) }
        else {contentTextView.updateText("Wow, ingen daglige temaer tilgjengelige") }
    }
    
    @IBAction func settingsAction(sender: UIBarButtonItem) {
        (tabBarController as? MainTabBarController)?.displayOptionsMenu(sender)
    }
    
    func showCalculator(){
        performSegueWithIdentifier("calculatorSegue", sender: self)
    }
    
    private func getFormattedCurrencyString() -> String{
        return formatter.stringFromNumber(userInfo.totalMoneySaved()) ?? "0"
    }
    
    private func initFormatter(){
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = " "
    }
}