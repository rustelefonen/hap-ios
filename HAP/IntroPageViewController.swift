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
        setViewControllers([viewControllerAtIndex(currentPage)], direction: .forward, animated: false, completion: nil)
        initIndicator()
        NotificationHandler.resetBadges()
    }
    
    func viewControllerAtIndex(_ index:Int) -> IntroContentViewController {
        if index >= introContentViews.count {
            let cvc = storyboard?.instantiateViewController(withIdentifier: viewControllerIds[index]) as! IntroContentViewController
            introContentViews.insert(cvc, at: index)
            introContentViews[index].pageIndex = index
        }
        return introContentViews[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! IntroContentViewController).pageIndex
        currentPage = index
        
        if index == NSNotFound || index <= 0 {
            view.backgroundColor = viewControllerAtIndex(index).view.backgroundColor
            return nil
        }
        return viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! IntroContentViewController).pageIndex
        currentPage = index
        
        if index == NSNotFound || index + 1 >= viewControllerIds.count {
            view.backgroundColor = viewControllerAtIndex(index).view.backgroundColor
            return nil
        }
        return viewControllerAtIndex(index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        indicator.currentPage = (viewControllers![0] as! IntroContentViewController).pageIndex
    }
    
    fileprivate func initIndicator(){
        indicator = UIPageControl(frame: CGRect(x: 0, y: view.frame.size.height - 37, width: view.frame.size.width, height: 37))
        indicator.backgroundColor = UIColor.clear
        indicator.pageIndicatorTintColor = UIColor.lightGray
        indicator.currentPageIndicatorTintColor = UIColor(red: 0xFF / 255, green: 0x4C / 255, blue: 0x3D / 255, alpha: 1)
        indicator.numberOfPages = viewControllerIds.count
        view.addSubview(indicator)
    }
    
    func finishIntro(){
        saveUserInfo()
        //DBSeeder.SeedDB()
        NotificationHandler.scheduleAchievementNotifications(AppDelegate.getUserInfo()!, force: true)
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    fileprivate func saveUserInfo(){
        let userInfoController = introContentViews[3] as! UserInfoIntroController
        let datePickerController = introContentViews[2] as! DatePickerIntroController
        
        let userInfoDao = UserInfoDao()
        let userInfo = userInfoDao.createNewUserInfo()
        
        if userInfoController.accepted.isOn {
            userInfo.age = userInfoController.age.text
            userInfo.gender = userInfoController.gender.text
            userInfo.geoState = userInfoController.state.text
            userInfo.userType = userInfoController.userType.text
        }
        
        
        let startDate = datePickerController.datePicker.date
        if startDate.compare(Date()) == .orderedDescending {
            userInfo.startDate = startDate.dateWithTimeAsStartOfDayOf()
        }
        else {
            userInfo.startDate = startDate.dateWithTimeAsOfNowOf()
        }
        
        userInfoDao.save()
        AppDelegate.initUserInfo() //reinit the newly created user
    }
}
