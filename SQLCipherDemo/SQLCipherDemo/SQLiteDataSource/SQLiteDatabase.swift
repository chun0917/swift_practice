//
//  SQLiteDatabase.swift
//  SQLCipherDemo
//
//  Created by 呂淳昇 on 2022/6/28.
//

import Foundation
import SQLite
class SQLiteDatabase{
    static let shared = SQLiteDatabase()
    var connect : Connection?
    
    private init(){
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(documentDirectory)
            let fireUrl = documentDirectory.appendingPathComponent("contactList").appendingPathExtension("sqlite3")
            print(fireUrl.path)
            connect = try Connection(fireUrl.path)
        }
        catch{
            print("connect failed:",error)
        }
    }
    
    func createTable(){
        SQLiteCommands.createTable()
    }
}
