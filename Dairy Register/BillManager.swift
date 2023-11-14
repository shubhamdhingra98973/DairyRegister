//
//  BillManager.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 27/08/23.
//

import Foundation

class BillManager : NSObject {
    
    static let shared = BillManager()
    
    private override init () {
        
    }
    
    
    func calculateTotalBuffaloMilkAmount(data : [String : Any]) -> Double {
        
        var totalAmount = 0.0
        //Amount calculation of buffalo milk
        if let isPackingMilk = data["isPackingMilk"] as? String, let TotalBuffaloMilk = data["TotalBuffaloMilk"] {
            
            if (isPackingMilk == kYes) {
                
                //Amount calculation of buffalo milk rate - (PACKING MILK)
                if let rate = data["PackingMilkRate"]{
                    totalAmount = convertValueToDouble(rate) * convertValueToDouble(TotalBuffaloMilk)
                } else {
                    totalAmount = convertValueToDouble(TotalBuffaloMilk) * 66
                }
            } else {
                //Amount calculation of buffalo milk rate - (NORMAL MILK)
                if let rate = data["NormalMilkRate"]{
                    totalAmount = convertValueToDouble(rate) * convertValueToDouble(TotalBuffaloMilk)
                } else {
                    totalAmount = convertValueToDouble(TotalBuffaloMilk) * 62
                }
            }
        }
        return totalAmount
    }
    
    func calculateTotalCowMilkAmount(data : [String : Any]) -> Double {
        var totalAmount = 0.0
        if let TotalCowMilk = data["TotalCowMilk"]{
            //Amount calculation of cow milk rate - (NORMAL MILK)
            if let rate = data["NormalMilkRate"] as? String {
                totalAmount = convertValueToDouble(rate) * convertValueToDouble(TotalCowMilk)
            } else {
                totalAmount = convertValueToDouble(TotalCowMilk) * 62
            }
        }
        return totalAmount
    }
    
    func getCowMilkRate(data : [String : Any]) -> Double {
        if let rate = data["NormalMilkRate"] as? String {
            return  convertValueToDouble(rate)
        } else {
            return 62.0
        }
    }
    
    
    func getBuffaloMilkRate(data : [String : Any]) -> Double {
        if let isPackingMilk = data["isPackingMilk"] as? String {
            if (isPackingMilk == kYes) {
                
                // (PACKING MILK)
                if let rate = data["PackingMilkRate"]{
                    return convertValueToDouble(rate)
                } else {
                    return 66
                }
            } else {
                //(NORMAL MILK)
                if let rate = data["NormalMilkRate"]{
                    return convertValueToDouble(rate)
                } else {
                   return 62
                }
            }
        }
        return 0.0
    }
    
    
    func convertValueToDouble(_ value : Any) -> Double{
        if let valueParsed = value as? Double {
            return valueParsed
        }
        if let valueParsed = value as? Int {
            return Double(valueParsed)
        }
        if let valueParsed = value as? Float {
            return Double(valueParsed)
        }
        if let valueParsed = value as? String {
            return Double(valueParsed) ?? 0.0
        }
        return 0.0
    }
    
    func getFinalPayableAmount(data : [String : Any] , totalMontlyAmount : CGFloat) -> Int {
        var finalPayableAmount = Int(totalMontlyAmount)
        
        if let balance = data["Balance"] {
            finalPayableAmount = finalPayableAmount + Int(BillManager.shared.convertValueToDouble(balance))
        }
        
        if let advance = data["Advance"] {
            finalPayableAmount = finalPayableAmount - Int(BillManager.shared.convertValueToDouble(advance))
        }
        return finalPayableAmount
    }
    
}
