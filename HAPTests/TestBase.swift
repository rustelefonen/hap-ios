//
//  TestBase.swift
//  HAP
//
//  Created by Fredrik Loberg on 11/05/16.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import XCTest

class TestBase: XCTestCase {

    func prePopulatedDb(){
        let fileManager = NSFileManager.defaultManager()
        let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let dbName = "HAP"
        
        let sqlite = NSBundle.mainBundle().pathForResource("db/\(dbName)", ofType: "sqlite")
        let sqliteshm = NSBundle.mainBundle().pathForResource("db/\(dbName)", ofType: "sqlite-shm")
        let sqlitewal = NSBundle.mainBundle().pathForResource("db/\(dbName)", ofType: "sqlite-wal")
        
        do{
            try fileManager.removeItemAtPath(documentFolder + "/\(dbName).sqlite")
            try fileManager.removeItemAtPath(documentFolder + "/\(dbName).sqlite-shm")
            try fileManager.removeItemAtPath(documentFolder + "/\(dbName).sqlite-wal")
            
            try fileManager.copyItemAtPath(sqlite!, toPath: documentFolder + "/\(dbName).sqlite")
            try fileManager.copyItemAtPath(sqliteshm!, toPath: documentFolder + "/\(dbName).sqlite-shm")
            try fileManager.copyItemAtPath(sqlitewal!, toPath: documentFolder + "/\(dbName).sqlite-wal")
        } catch _{}
    }
    
}
