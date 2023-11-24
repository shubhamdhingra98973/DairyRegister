//
//  Utility.swift
//  Printer
//
//  Created by Shubham Dhingra on 19/08/23.
//  Copyright © 2023 Admin. All rights reserved.
//

import Foundation
import UIKit

struct RangeAttribute {
    var key : NSAttributedString.Key
    var value : Any
}




class Utility : NSObject {
    
    static let shared = Utility()
    
    private override init () {
        
    }
    
    func noOfLinesTakenByContent(text : String , font : FontFamilyAndSize, contentArea : CGSize) -> Int {
        let font = UIFont.systemFont(ofSize: 16)
               let attributes: [NSAttributedString.Key: Any] = [
                   .font: font
               ]
               
               // Calculate text size with line wrapping
//               let maxSize = CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude)
               let maxSize = contentArea
               let textBoundingRect = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
               
               // Calculate the number of lines
               let lineHeight = font.lineHeight
               let numberOfLines = Int(ceil(textBoundingRect.height / lineHeight))
               print("Text : \(text) Line Taken : \(numberOfLines)")
               return numberOfLines
    }
    
    func isiPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    func getFont(fontInfo : FontFamilyAndSize) -> UIFont {
       
        switch fontInfo {
        case .BoldSize10:
            return UIFont.boldSystemFont(ofSize: 10)
        case .BoldSize12:
            return UIFont.boldSystemFont(ofSize: 12)
        case .BoldSize14:
            return UIFont.boldSystemFont(ofSize: 14)
        case .BoldSize16:
            return UIFont.boldSystemFont(ofSize: 16)
        case .BoldSize18:
            return UIFont.boldSystemFont(ofSize: 18)
        case .BoldSize20:
            return UIFont.boldSystemFont(ofSize: 20)
        case .BoldSize24:
            return UIFont.boldSystemFont(ofSize: 24)
        case .RegularSize10:
            return UIFont.systemFont(ofSize: 10)
        case .RegularSize12:
            return UIFont.systemFont(ofSize: 12)
        case .RegularSize14:
            return UIFont.systemFont(ofSize: 14)
        case .RegularSize16:
            return UIFont.systemFont(ofSize: 16)
        case .RegularSize18:
            return UIFont.systemFont(ofSize: 18)
        case .RegularSize20:
            return UIFont.systemFont(ofSize: 20)
        case .RegularSize24:
            return UIFont.systemFont(ofSize: 24)
        }
    }
    
    func getMonthText(monthNumber : Int) -> String {
        
        switch monthNumber {
        case 1:
            return "जनवरी"
        case 2:
            return "फरवरी"
        case 3:
            return "मार्च"
        case 4:
            return "अप्रैल"
        case 5:
            return "मई"
        case 6:
            return "जून"
        case 7:
            return "जुलाई"
        case 8:
            return "अगस्त"
        case 9:
            return "सितम्बर"
        case 10:
            return "अक्टूबर"
        case 11:
            return "नवम्बर"
        case 12:
            return "दिसम्बर"
        default:
            return ""
        }
    }
    
    func getCurrentYear() -> Int{
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return currentYear
        
    }
    
    func getCurrentMonth() -> Int{
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        return currentMonth
    }
    
    func getPaperHeight(data : [String : Any]) -> CGFloat {
        var paperHeight =  Utility.shared.isiPad() ? IPadPaperDimensions.PaperHeight.value : PaperDimensions.PaperHeight.value
        let paperWidth =  Utility.shared.isiPad() ? IPadPaperDimensions.PaperWidth.value : PaperDimensions.PaperWidth.value
        let customerNameTextRect : CGFloat = 58
        if let customerName = data["CustomerName"] as? String {
            let lineTakenByName = Utility.shared.noOfLinesTakenByContent(text: "\(customerName)", font: .BoldSize12, contentArea: CGSize(width: paperWidth - CGFloat(customerNameTextRect), height: paperHeight))
            print("Line taken by Name :",lineTakenByName)
            if (lineTakenByName > 1) {
                paperHeight = paperHeight + 20
            }
        }
        
        if data["Balance"] == nil  || data["Balance"] as? String == "0" {
            print("Balance : Height Reduced")
            paperHeight = paperHeight - 20
        }
        if data["Advance"] == nil || data["Advance"] as? String == "0" {
            print("Advance : Height Reduced")
            paperHeight = paperHeight - 20
        }
        if data["TotalCowMilk"] == nil || data["TotalCowMilk"] as? String == "0" {
            print("TotalCowMilk : Height Reduced")
            paperHeight = paperHeight - 20
        }
        return paperHeight
    }
    
    func createAttributedString(str1 : String , attr1 : [NSAttributedString.Key : Any]? , rangeAttr1 : RangeAttribute? = nil, str2 : String , attr2 : [NSAttributedString.Key : Any]? , rangeAttr2 : RangeAttribute? = nil) -> NSMutableAttributedString {
        
        let attStr1 = NSMutableAttributedString(string: str1, attributes: attr1)
        
        if let rangeAttr1 = rangeAttr1 {
            attStr1.addAttribute(rangeAttr1.key , value : rangeAttr1.value , range: NSMakeRange(0, attStr1.length))
        }
        
        if /attr2?.count == 0 {
            return attStr1
        }
        
        let attStr2 = NSMutableAttributedString(string: str2 , attributes: attr2)
        
        if let rangeAttr2 = rangeAttr2 {
            attStr2.addAttribute(rangeAttr2.key , value : rangeAttr2.value , range: NSMakeRange(0, attStr2.length))
        }
        
        attStr1.append(attStr2)
        return attStr1
    }
    
    func makeToast(_ message: String?, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = ToastManager.shared.position, title: String? = nil, image: UIImage? = nil, style: ToastStyle = ToastManager.shared.style, completion: ((_ didTap: Bool) -> Void)? = nil) {
        if let topVc = self.topMostViewController {
            topVc.view.makeToast(message, duration: duration, title: title, image: image, style: style) { didTap in
                if let block = completion {
                    block(didTap)
                }
            }
        }
    }
    
}
