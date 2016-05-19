//
//  RemoteDataSource.swift
//  HAP
//
//  Created by Fredrik Loberg on 13/04/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import UIKit

class RemoteInfoDataSource {
    static let SERVER_URL = "http://app.rustelefonen.no"
    
    let localCategories:[HelpInfoCategory]!
    let infoDao:HelpInfoDao!
    var requestsDone = 0
    
    init(){
        infoDao = HelpInfoDao()
        localCategories = infoDao.fetchAllHelpInfoCategories()
    }
    
    func syncDatabase(){
        let request = makeJsonRequestForUrl("\(RemoteInfoDataSource.SERVER_URL)/api/info/version")
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in self.handleVersionDataFromServer(data)}).resume()
    }
    
    private func handleVersionDataFromServer(data:NSData?){
        if data == nil { return }
        var remoteCategories: [HelpInfoCategory.Summary] = []
        
        if let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) {
            for remote in json.allObjects as? [[String: Int]] ?? [] {
                remoteCategories.append(HelpInfoCategory.Summary(id: remote["id"]!, versionNumber: remote["versionNumber"]!))
            }
        }
        
        if remoteCategories.isEmpty { return }
        
        deleteCategoriesNotPresentOnRemote(remoteCategories)
        let categoriesToUpdate = collectCategoriesToUpdate(remoteCategories)
        updateOutdatedCategories(categoriesToUpdate)
    }
    
    private func deleteCategoriesNotPresentOnRemote(remoteCategories:[HelpInfoCategory.Summary]) {
        let notOnRemote = localCategories.filter({ (locale) in
            return !remoteCategories.contains({ (remote) in Int(locale.categoryId) == remote.id })
        })
        infoDao.deleteObjects(notOnRemote)
    }
    
    private func collectCategoriesToUpdate(remoteCategories:[HelpInfoCategory.Summary]) -> [HelpInfoCategory.Summary]{
        return remoteCategories.filter({ (remote) in
            let local = localCategories.filter({(c) in remote.id == Int(c.categoryId)}).first
            return local == nil || Int(local!.versionNumber) < remote.versionNumber
        })
    }
    
    func updateOutdatedCategories(categoriesToUpdate:[HelpInfoCategory.Summary]){
        synced(self){ self.requestsDone = categoriesToUpdate.count }
        
        for cat in categoriesToUpdate {
            let request = makeJsonRequestForUrl("\(RemoteInfoDataSource.SERVER_URL)/api/info/categories/\(cat.id)")
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in self.updateRecievedCategory(data)}).resume()
        }
        
    }
    
    func updateRecievedCategory(data:NSData?){
        synced(self){ self.requestsDone -= 1 }
        if data == nil { return }
        
        if let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) {
            let catId = json["id"] as? NSNumber ?? -1
            let currentLocal = infoDao.fetchCategoryById(Int(catId))
            
            let c = infoDao.createNewHelpInfoCategory()
            c.categoryId = catId
            c.title = json["title"] as? String ?? ""
            c.order = json["orderNumber"] as? NSNumber ?? 0
            c.versionNumber = json["versionNumber"] as? NSNumber ?? 1
                
            var infos = [HelpInfo]()
            for info in json["info"] as? [[String: AnyObject]] ?? []{
                let i = infoDao.createNewHelpInfo()
                i.title = info["title"] as? String ?? ""
                i.htmlContent = info["htmlContent"] as? String ?? ""
                infos.append(i)
            }
            
            c.helpInfo = NSSet(array: infos)
            
            do{
                try c.validateForInsert()
                print("saving")
                if currentLocal != nil { infoDao.delete(currentLocal!) }
            } catch _{
                infoDao.delete(c)
            }
        }
        
        synced(self){
            if self.requestsDone <= 0{
                print("done")
                self.infoDao.save()
                SwiftEventBus.post(HelpInfoTableController.RELOAD_INFO_EVENT)
            }
        }
    }
    
    private func makeJsonRequestForUrl(url:String) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func synced(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}