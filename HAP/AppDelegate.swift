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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setDefaultAppearances()
        AppDelegate.initUserInfo()
        applicationWillEnterForeground(application)
        
        //Allow notifications
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge], categories: nil))
        
        if(userInfo != nil) { NotificationHandler.scheduleAchievementNotifications(userInfo!) }
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NotificationHandler.notifyNotificationRecieved()
    }
    
    func setDefaultAppearances(){
        UINavigationBar.appearance().barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(red: 1, green: 0.3, blue: 0.24, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 1, green: 0.3, blue: 0.24, alpha: 1)]
        UITabBar.appearance().tintColor = UINavigationBar.appearance().tintColor
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationHandler.syncListenerBadges()
        RemoteInfoDataSource().syncDatabase()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "HAP", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let dbName = "HAP"
        self.initPrePopulatedDb(dbName)
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let storePath = self.applicationDocumentsDirectory.appendingPathComponent("\(dbName).sqlite")
        print(storePath)
        
        let failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storePath, options: options)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
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
    
    fileprivate func initPrePopulatedDb(_ dbName:String){
        let fileManager = FileManager.default
        let documentFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        if !fileManager.fileExists(atPath: documentFolder + "/\(dbName).sqlite") {
            let sqlite = Bundle.main.path(forResource: "db/\(dbName)", ofType: "sqlite")
            let sqliteshm = Bundle.main.path(forResource: "db/\(dbName)", ofType: "sqlite-shm")
            let sqlitewal = Bundle.main.path(forResource: "db/\(dbName)", ofType: "sqlite-wal")
            
            try! fileManager.copyItem(atPath: sqlite!, toPath: documentFolder + "/\(dbName).sqlite")
            try! fileManager.copyItem(atPath: sqliteshm!, toPath: documentFolder + "/\(dbName).sqlite-shm")
            try! fileManager.copyItem(atPath: sqlitewal!, toPath: documentFolder + "/\(dbName).sqlite-wal")
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
        return UIApplication.shared.delegate as! AppDelegate
    }
}
