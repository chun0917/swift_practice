//
//  SQLiteCommands.swift
//  SQLCipherDemo
//
//  Created by 呂淳昇 on 2022/6/28.
//

import Foundation
import SQLite

class SQLiteCommands{
    static var table = Table("contact")
    
    static let name = Expression<String>("name")
    static let phoneNumber = Expression<String>("phoneNumber")
    //建立資料表
    static func createTable(){
        guard let database = SQLiteDatabase.shared.connect else{
            print("database connection error")
            return
        }
        do{
            try database.run(table.create(ifNotExists:true){ table in
                table.column(name,primaryKey: true)
                table.column(phoneNumber,unique: true)
            })
        }
        catch{
            print("table already exists",error)
        }
    }
    //新增資料
    static func insertRow(_ contactValues:Contact)-> Bool?{
        guard let database = SQLiteDatabase.shared.connect else{
            print("database connection error")
            return nil
        }
        do{
            try database.run(table.insert(name <- contactValues.name,
                                          phoneNumber <- contactValues.phoneNumber))
            return true
        }
        catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT{
            print("insert failed:\(message),in\(String(describing: statement))")
            return false
        }
        catch let error{
            print(error)
            return false
        }
    }
    //修改資料
    static func updateRow(_ contactValues:Contact)-> Bool?{
        guard let database = SQLiteDatabase.shared.connect else{
            print("database connection error")
            return nil
        }
        let contact = table.filter(name == contactValues.name).limit(1)
        do{
            if try database.run(contact.update(phoneNumber <- contactValues.phoneNumber)) > 0{
                print("update contact")
                return true
            }else{
                print("could not update contact")
                return false
            }
        }
        catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT{
            print("update failed:\(message),in\(String(describing: statement))")
            return false
        }
        catch let error{
            print(error)
            return false
        }
    }
    //顯示資料
    static func presentRows()->[Contact]?{
        guard let database = SQLiteDatabase.shared.connect else{
            print("error")
            return nil
        }
        var contactArray = [Contact]()
        
        table = table.order(name.desc)
        
        do{
            for contact in try database.prepare(table){
                let nameValue = contact[name]
                let phoneNumberValue = contact[phoneNumber]
                
                let contactObject = Contact(name: nameValue, phoneNumber: phoneNumberValue)
                
                contactArray.append(contactObject)
                print("name:\(contact[name]),phoneNumber:\(contact[phoneNumber])")
            }
        }
        catch{
            print(error)
        }
        return contactArray
    }
}
