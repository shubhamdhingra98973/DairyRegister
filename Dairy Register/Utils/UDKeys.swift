//
//  UDKeys.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 31/08/23.
//


import Foundation
import UIKit

let kGroupSuiteName = "group.com.hushbunny.app"

enum UDKeys: String{
    
    case CustomerNamesList  = "customerNamesList"
    case CustomerRecordList = "customerRecordList"
    
    func save(_ value: Any) {
        
        switch self{
            
            //        case .CustomerNamesList:
            //            UserDefaults(suiteName: kGroupSuiteName)?.set(value, forKey: self.rawValue)
            //            break
            //        case .CustomerRecordList:
            //            UserDefaults(suiteName: kGroupSuiteName)?.set(value, forKey: self.rawValue)
            //            break
            
        default:
            UserDefaults.standard.set(value, forKey: self.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func fetch() -> Any? {
        
        switch self{
            
        case .CustomerRecordList , .CustomerNamesList:
            guard let data = UserDefaults.standard.value(forKey: self.rawValue) else { return nil}
            return data
        }
    }
    
    func remove() {
        switch self {
        case .CustomerNamesList , .CustomerRecordList:
            UserDefaults(suiteName: kGroupSuiteName)?.removeObject(forKey: self.rawValue)
        default:
            UserDefaults.standard.removeObject(forKey: self.rawValue)
        }
    }
    
}

class UserDefaultManager {
    
    class func getCustomerNamesList() -> [String] {
        if let customerNamesDTO = UDKeys.CustomerNamesList.fetch() as? [String] {
            let filteredList = customerNamesDTO.filter { (value) -> Bool in
                return value.trim().count > 0
            }
            return filteredList
        }
        return []
    }
    
    class func updateCustomerRecordList(name : String , customerRecord : [String : Any]) -> Bool {
        var update = false
        var recordList = [[String : Any]]()
        if let customerRecordList = UDKeys.CustomerRecordList.fetch() as? [[String : Any]] {
            recordList = customerRecordList
            for (index , value) in recordList.enumerated() {
                if let customerName = value[CustomerDataKeys.CustomerName.value] as? String {
                    if (customerName == name) {
                        update = true
                        recordList[index] = customerRecord
                        UDKeys.CustomerRecordList.save(recordList)
                    }
                }
            }
            if !(update) {
                recordList.append(customerRecord)
                UDKeys.CustomerRecordList.save(recordList)
            }
        } else {
            update = true
            //Only For First time when their is no data
            recordList.append(customerRecord)
            UDKeys.CustomerRecordList.save(recordList)
        }
        addCustomerNameInTheList(name: name)
        return update
    }
    
    class func addCustomerNameInTheList(name : String) {
        var customerNameList = [String]()
        var update = false
        if let customerNamesDTO = UDKeys.CustomerNamesList.fetch() as? [String] {
            customerNameList = customerNamesDTO
            for (index , CstName) in customerNameList.enumerated() {
                if (CstName == name) {
                    update = true
                    customerNameList[index] = name
                    UDKeys.CustomerNamesList.save(customerNameList)
                }
            }
            if !(update) {
                customerNameList.append(name)
                UDKeys.CustomerNamesList.save(customerNameList)
            }
            else {
                if (!update) {
                    update = true
                    //Only For First time when their is no data
                    customerNameList.append(name)
                    UDKeys.CustomerNamesList.save(customerNameList)
                }
            }
        }
    }
}


