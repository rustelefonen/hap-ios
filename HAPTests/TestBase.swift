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
        let fileManager = FileManager.default
        let documentFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbName = "HAP"
        
        let sqlite = Bundle.main.path(forResource: "db/\(dbName)", ofType: "sqlite")
        let sqliteshm = Bundle.main.path(forResource: "db/\(dbName)", ofType: "sqlite-shm")
        let sqlitewal = Bundle.main.path(forResource: "db/\(dbName)", ofType: "sqlite-wal")
        
        do{
            try fileManager.removeItem(atPath: documentFolder + "/\(dbName).sqlite")
            try fileManager.removeItem(atPath: documentFolder + "/\(dbName).sqlite-shm")
            try fileManager.removeItem(atPath: documentFolder + "/\(dbName).sqlite-wal")
            
            try fileManager.copyItem(atPath: sqlite!, toPath: documentFolder + "/\(dbName).sqlite")
            try fileManager.copyItem(atPath: sqliteshm!, toPath: documentFolder + "/\(dbName).sqlite-shm")
            try fileManager.copyItem(atPath: sqlitewal!, toPath: documentFolder + "/\(dbName).sqlite-wal")
        } catch _{}
    }
    
}
