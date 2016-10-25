//
//  RemoteUserInfo.swift
//  HAP
//
//  Created by Simen Fonnes on 06.05.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//
import UIKit

class RemoteUserInfo {
    
    static let hasSent = "hasSentResearch"
    static let url = "http://app.rustelefonen.no/api/research"
    
    class func postDataToServer(_ age:String?, gender:String?, county:String?) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod =  "POST"
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        var params = ""
        if age != nil && !age!.isEmpty { params += "age=\(age!)&" }
        if gender != nil && !gender!.isEmpty { params += "gender=\(gender!)&" }
        if county != nil && !county!.isEmpty { params += "county=\(county!)" }
        params = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        request.httpBody = params.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in self.handleResearchRequest(data) }).resume()
    }
    
    fileprivate class func handleResearchRequest(_ data:Data?) {
        if data != nil { UserDefaults.standard.set(true, forKey: RemoteUserInfo.hasSent) }
    }
    
    class func loadHasSentResearch() -> Bool{
        return UserDefaults.standard.bool(forKey: RemoteUserInfo.hasSent)
    }
}
