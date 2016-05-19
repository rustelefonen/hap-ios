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
    
    class func postDataToServer(age:String?, gender:String?, county:String?) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod =  "POST"
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        var params = ""
        if age != nil && !age!.isEmpty { params += "age=\(age!)&" }
        if gender != nil && !gender!.isEmpty { params += "gender=\(gender!)&" }
        if county != nil && !county!.isEmpty { params += "county=\(county!)" }
        params = params.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) ?? ""
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in self.handleResearchRequest(data) }).resume()
    }
    
    private class func handleResearchRequest(data:NSData?) {
        if data != nil { NSUserDefaults.standardUserDefaults().setBool(true, forKey: RemoteUserInfo.hasSent) }
    }
    
    class func loadHasSentResearch() -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(RemoteUserInfo.hasSent)
    }
}
