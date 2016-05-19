//
//  ViewController.swift
//  HAP
//
//  Created by Simen Fonnes on 28.01.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

class IntroPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    static let storyboardId = "IntroController"
    
    var viewControllerIds = [HelloViewController.storyboardId, DisclaimerIntroController.storyboardId, DatePickerIntroController.storyboardId, UserInfoIntroController.storyboardId]
    var introContentViews = [IntroContentViewController]()
    var currentPage = 0
    var indicator: UIPageControl!
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        setViewControllers([viewControllerAtIndex(currentPage)], direction: .Forward, animated: false, completion: nil)
        initIndicator()
        NotificationHandler.resetBadges()
    }
    
    func viewControllerAtIndex(index:Int) -> IntroContentViewController {
        if index >= introContentViews.count {
            let cvc = storyboard?.instantiateViewControllerWithIdentifier(viewControllerIds[index]) as! IntroContentViewController
            introContentViews.insert(cvc, atIndex: index)
            introContentViews[index].pageIndex = index
        }
        return introContentViews[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! IntroContentViewController).pageIndex
        currentPage = index
        
        if index == NSNotFound || index <= 0 {
            view.backgroundColor = viewControllerAtIndex(index).view.backgroundColor
            return nil
        }
        return viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! IntroContentViewController).pageIndex
        currentPage = index
        
        if index == NSNotFound || index + 1 >= viewControllerIds.count {
            view.backgroundColor = viewControllerAtIndex(index).view.backgroundColor
            return nil
        }
        return viewControllerAtIndex(index + 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        indicator.currentPage = (viewControllers![0] as! IntroContentViewController).pageIndex
    }
    
    private func initIndicator(){
        indicator = UIPageControl(frame: CGRect(x: 0, y: view.frame.size.height - 37, width: view.frame.size.width, height: 37))
        indicator.backgroundColor = UIColor.clearColor()
        indicator.pageIndicatorTintColor = UIColor.lightGrayColor()
        indicator.currentPageIndicatorTintColor = UIColor(red: 0xFF / 255, green: 0x4C / 255, blue: 0x3D / 255, alpha: 1)
        indicator.numberOfPages = viewControllerIds.count
        view.addSubview(indicator)
    }
    
    func finishIntro(){
        saveUserInfo()
        //DBSeeder.SeedDB()
        NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!, force: true)
        presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    private func saveUserInfo(){
        let userInfoController = introContentViews[3] as! UserInfoIntroController
        let datePickerController = introContentViews[2] as! DatePickerIntroController
        
        let userInfoDao = UserInfoDao()
        let userInfo = userInfoDao.createNewUserInfo()
        
        if userInfoController.accepted.on {
            userInfo.age = userInfoController.age.text
            userInfo.gender = userInfoController.gender.text
            userInfo.geoState = userInfoController.state.text
        }
        
        
        let startDate = datePickerController.datePicker.date
        if startDate.compare(NSDate()) == .OrderedDescending {
            userInfo.startDate = startDate.dateWithTimeAsStartOfDayOf()
        }
        else {
            userInfo.startDate = startDate.dateWithTimeAsOfNowOf()
        }
        
        userInfoDao.save()
        AppDelegate.initUserInfo() //reinit the newly created user
    }
}
