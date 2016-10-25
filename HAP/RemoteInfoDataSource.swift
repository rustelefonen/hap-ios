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
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in self.handleVersionDataFromServer(data)}).resume()
    }
    
    fileprivate func handleVersionDataFromServer(_ data:Data?){
        if data == nil { return }
        var remoteCategories: [HelpInfoCategory.Summary] = []
        
        if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
            for remote in (json as AnyObject).allObjects as? [[String: Int]] ?? [] {
                remoteCategories.append(HelpInfoCategory.Summary(id: remote["id"]!, versionNumber: remote["versionNumber"]!))
            }
        }
        
        if remoteCategories.isEmpty { return }
        
        deleteCategoriesNotPresentOnRemote(remoteCategories)
        let categoriesToUpdate = collectCategoriesToUpdate(remoteCategories)
        updateOutdatedCategories(categoriesToUpdate)
    }
    
    fileprivate func deleteCategoriesNotPresentOnRemote(_ remoteCategories:[HelpInfoCategory.Summary]) {
        let notOnRemote = localCategories.filter({ (locale) in
            return !remoteCategories.contains(where: { (remote) in Int(locale.categoryId) == remote.id })
        })
        infoDao.deleteObjects(notOnRemote)
    }
    
    fileprivate func collectCategoriesToUpdate(_ remoteCategories:[HelpInfoCategory.Summary]) -> [HelpInfoCategory.Summary]{
        return remoteCategories.filter({ (remote) in
            let local = localCategories.filter({(c) in remote.id == Int(c.categoryId)}).first
            return local == nil || Int(local!.versionNumber) < remote.versionNumber
        })
    }
    
    func updateOutdatedCategories(_ categoriesToUpdate:[HelpInfoCategory.Summary]){
        synced(self){ self.requestsDone = categoriesToUpdate.count }
        
        for cat in categoriesToUpdate {
            let request = makeJsonRequestForUrl("\(RemoteInfoDataSource.SERVER_URL)/api/info/categories/\(cat.id)")
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error in self.updateRecievedCategory(data)}).resume()
        }
        
    }
    
    func updateRecievedCategory(_ data:Data?){
        synced(self){ self.requestsDone -= 1 }
        if data == nil { return }
        
        if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any] {
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
    
    fileprivate func makeJsonRequestForUrl(_ url:String) -> NSMutableURLRequest{
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func synced(_ lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}
