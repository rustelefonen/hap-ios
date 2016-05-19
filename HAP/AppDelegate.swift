//
//  AppDelegate.swift
//  HAP
//
//  Created by Simen Fonnes on 14.01.16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userInfo: UserInfo?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setDefaultAppearances()
        AppDelegate.initUserInfo()
        applicationWillEnterForeground(application)
        
        //Allow notifications
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil))
        
        if(userInfo != nil) { NotificationHandler.scheduleAchievementNotifications(userInfo!) }
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        NotificationHandler.notifyNotificationRecieved()
    }
    
    func setDefaultAppearances(){
        UINavigationBar.appearance().barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(red: 1, green: 0.3, blue: 0.24, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 1, green: 0.3, blue: 0.24, alpha: 1)]
        UITabBar.appearance().tintColor = UINavigationBar.appearance().tintColor
    }

    func applicationWillEnterForeground(application: UIApplication) {
        NotificationHandler.syncListenerBadges()
        RemoteInfoDataSource().syncDatabase()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        saveContext()
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("HAP", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let dbName = "HAP"
        self.initPrePopulatedDb(dbName)
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let storePath = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(dbName).sqlite")
        print(storePath)
        
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storePath, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    private func initPrePopulatedDb(dbName:String){
        let fileManager = NSFileManager.defaultManager()
        let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        if !fileManager.fileExistsAtPath(documentFolder + "/\(dbName).sqlite") {
            let sqlite = NSBundle.mainBundle().pathForResource("db/\(dbName)", ofType: "sqlite")
            let sqliteshm = NSBundle.mainBundle().pathForResource("db/\(dbName)", ofType: "sqlite-shm")
            let sqlitewal = NSBundle.mainBundle().pathForResource("db/\(dbName)", ofType: "sqlite-wal")
            
            try! fileManager.copyItemAtPath(sqlite!, toPath: documentFolder + "/\(dbName).sqlite")
            try! fileManager.copyItemAtPath(sqliteshm!, toPath: documentFolder + "/\(dbName).sqlite-shm")
            try! fileManager.copyItemAtPath(sqlitewal!, toPath: documentFolder + "/\(dbName).sqlite-wal")
        }
    }
    
    class func getManagedObjectContext() -> NSManagedObjectContext{
        return getAppDelegate().managedObjectContext
    }
    
    class func initUserInfo(){
        getAppDelegate().userInfo = UserInfoDao().fetchUserInfo()
    }
    
    class func getUserInfo() -> UserInfo?{
        return getAppDelegate().userInfo
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}