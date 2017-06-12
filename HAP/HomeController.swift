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
    @IBOutlet weak var questionCard: UIView!
    
    @IBOutlet weak var navigateToSurvey: UILabel!
    @IBOutlet weak var surveyTextView: UITextView!
    
    let formatter = NumberFormatter()
    var updateTimer:Timer!
    
    override func viewDidLoad() {
        userInfo = AppDelegate.getUserInfo()
        initFormatter()
        updateDailySubject()
        moneySavedLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCalculator)))
        
        navigateToSurvey.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (registerQuestion)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(updateTimer, forMode: RunLoopMode.commonModes)
        
        displayQuestionCard()
        setSurveyText()
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
    
    func registerQuestion() {
        if let currentSurvey = getCurrentSurvey() {
            self.performSegue(withIdentifier: "surveySegue", sender: currentSurvey)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SurveyController.segueId {
            let destinationVC = segue.destination as! SurveyController
            
            let userInfoDao = UserInfoDao()
            let currentSurvey = sender as! Int
            if currentSurvey == 0 && userInfo.surveyRegistered == nil {
                destinationVC.url = "https://no.surveymonkey.com/r/VC9RY62"
                userInfo.surveyRegistered = Date()
                userInfoDao.save()
                AppDelegate.initUserInfo()
            }
            else if currentSurvey == 1 && userInfo.surveyRegistered != nil && userInfo.secondSurveyRegistered == nil{
                destinationVC.url = "https://no.surveymonkey.com/r/2RZ29SM"
                userInfo.secondSurveyRegistered = Date()
                userInfoDao.save()
                AppDelegate.initUserInfo()
            }
            else if currentSurvey == 2 && userInfo.surveyRegistered != nil && userInfo.thirdSurveyRegistered == nil{
                destinationVC.url = "https://no.surveymonkey.com/r/SGKKT2R"
                userInfo.thirdSurveyRegistered = Date()
                userInfoDao.save()
                AppDelegate.initUserInfo()
            }
        }
    }
    
    func displayQuestionCard() {
        if userInfo.appRegistered == nil {
            questionCard.isHidden = true
            return
        }
        let firstSurveyBegin = userInfo.appRegistered!
        let firstSurveyEnd = Calendar.current.date(byAdding: .day, value: 7, to: firstSurveyBegin)!
        let now = Date()
        
        let firstDateRegistered = userInfo.surveyRegistered
        if firstDateRegistered == nil {
            if now >= firstSurveyBegin && now < firstSurveyEnd  {questionCard.isHidden = false}
            else {questionCard.isHidden = true}
            return
        }
        
        if userInfo.secondSurveyRegistered == nil || userInfo.thirdSurveyRegistered == nil {
            let secondDate = Calendar.current.date(byAdding: .day, value: 56, to: firstDateRegistered!)!
            let secondDateEnd = Calendar.current.date(byAdding: .day, value: 66, to: firstDateRegistered!)!
            let thirdDate = Calendar.current.date(byAdding: .day, value: 280, to: firstDateRegistered!)!
            let thirdDateEnd = Calendar.current.date(byAdding: .day, value: 290, to: firstDateRegistered!)!
            
            if (now >= secondDate && now < secondDateEnd) || (now >= thirdDate && now < thirdDateEnd) {
                questionCard.isHidden = false
                return
            }
        }
        questionCard.isHidden = true
    }
    
    func setSurveyText() {
        var content = "Har du 10 minutter til å være med på en anonym undersøkelse om app som hjelpetilbud?"
        
        if userInfo.appRegistered == nil {return}
        
        let firstSurveyBegin = userInfo.appRegistered!
        let firstSurveyEnd = Calendar.current.date(byAdding: .day, value: 7, to: firstSurveyBegin)!
        let now = Date()
        
        let firstDateRegistered = userInfo.surveyRegistered
        if firstDateRegistered == nil {
            if now >= firstSurveyBegin && now < firstSurveyEnd  {
                let timeRemaining = Calendar.current.dateComponents([.second], from: now, to: firstSurveyEnd).second ?? 0
                content += " Undersøkelsen er åpen i \(formatTimeRemaining(timeRemaining: timeRemaining)) til."
                surveyTextView.text = content
                return
            }
            else {return}
        }
        
        let secondDate = Calendar.current.date(byAdding: .day, value: 56, to: firstDateRegistered!)!
        let secondDateEnd = Calendar.current.date(byAdding: .day, value: 66, to: firstDateRegistered!)!
        
        if now >= secondDate && now < secondDateEnd {
            let timeRemaining = Calendar.current.dateComponents([.second], from: now, to: secondDateEnd).second ?? 0
            content += " Undersøkelsen er åpen i \(formatTimeRemaining(timeRemaining: timeRemaining)) til."
            surveyTextView.text = content
            return
        }
        
        let thirdDate = Calendar.current.date(byAdding: .day, value: 280, to: firstDateRegistered!)!
        let thirdDateEnd = Calendar.current.date(byAdding: .day, value: 290, to: firstDateRegistered!)!
        
        if now >= thirdDate && now < thirdDateEnd {
            let timeRemaining = Calendar.current.dateComponents([.second], from: now, to: thirdDateEnd).second ?? 0
            content += " Undersøkelsen er åpen i \(formatTimeRemaining(timeRemaining: timeRemaining)) til."
            surveyTextView.text = content
            return
        }
        
    }
    
    func formatTimeRemaining(timeRemaining:Int) ->String{
        if timeRemaining >= 86400 {
            let days = timeRemaining / 86400
            if days == 1 {return "1 dag"}
            else {return "\(days) dager"}
        }
        else if timeRemaining < 86400 && timeRemaining >= 3600 {
            let hours = timeRemaining / 3600
            if hours == 1 {return "1 time"}
            else {return "\(hours) timer"}
        }
        else if timeRemaining < 3600 {
            let minutes = timeRemaining / 60
            if minutes == 1 {return "1 minutt"}
            else {return "\(minutes) minutter"}
        }
        return ""
    }
    
    func getCurrentSurvey() -> Int? {
        if userInfo.appRegistered == nil {return nil}
        
        let firstSurveyBegin = userInfo.appRegistered!
        let firstSurveyEnd = Calendar.current.date(byAdding: .day, value: 7, to: firstSurveyBegin)!
        let now = Date()
        
        let firstDateRegistered = userInfo.surveyRegistered
        if firstDateRegistered == nil {
            if now >= firstSurveyBegin && now < firstSurveyEnd  {return 0}
            else {return nil}
        }
        
        let secondDate = Calendar.current.date(byAdding: .day, value: 56, to: firstDateRegistered!)!
        let secondDateEnd = Calendar.current.date(byAdding: .day, value: 66, to: firstDateRegistered!)!
        
        if now >= secondDate && now < secondDateEnd {return 1}
        
        let thirdDate = Calendar.current.date(byAdding: .day, value: 280, to: firstDateRegistered!)!
        let thirdDateEnd = Calendar.current.date(byAdding: .day, value: 290, to: firstDateRegistered!)!
        
        if now >= thirdDate && now < thirdDateEnd {return 2}
        
        return nil
    }
}
