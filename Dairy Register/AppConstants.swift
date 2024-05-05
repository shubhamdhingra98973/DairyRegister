//
//  AppConstants.swift
//  Printer
//
//  Created by Shubham Dhingra on 18/08/23.
//  Copyright © 2023 Admin. All rights reserved.
//

import Foundation
import UIKit

enum FontFamilyAndSize {
    case BoldSize8
    case BoldSize10
    case BoldSize12
    case BoldSize14
    case BoldSize16
    case BoldSize18
    case BoldSize20
    case BoldSize24
    case RegularSize8
    case RegularSize10
    case RegularSize12
    case RegularSize14
    case RegularSize16
    case RegularSize18
    case RegularSize20
    case RegularSize24
}

let kYes = "1"
let kNo = "0"


enum MonthEnum : Int {
    case January = 1
    case Febrary = 2
    case March = 3
    case April = 4
    case May = 5
    case June = 6
    case July = 7
    case August = 8
    case September = 9
    case October = 10
    case November = 11
    case December = 12
}


enum BillConstants: String {
    case BusinessName = "ओम साईं राम डेयरी फार्म"
    case MainBusinesName  = "पप्पू डेयरी फार्म"
    case Address  = "कमला नगर, आगरा"
    case CustomerName = "ग्राहक का नाम"
    case SerialNo = "क्रमांक"
    case Milk = "दूध"
    case Total = "कुल"
    case rupees = "₹"
    case buffalo = "भैंस"
    case cow = "गाय"
    case kullLitre = "कुल (लीटर)"
    case TotalInRupees = "राशि (₹)"
    case totalMontlyAmount = "माह की कुल राशि (Total)"
    case balanceAmount = "शेष राशि (Balance) (+)"
    case AdvanceAmount = "पूर्व भुगतान (Advance) (-)"
    case finalPayableAmount = "भुगतान राशि"
    case Note = "नोट :-"
    case milkRateNote66 = "1) 01/05/2024 से दूध का रेट ₹66 प्रति लीटर"
    case milkRateNote70 = "1) 01/05/2024 से दूध का रेट ₹70 प्रति लीटर"
    case milkRateNoteFor70 = "***  01/05/2024 से दूध का रेट  *** \n(भैंस): ₹70 प्रति ली  |  (गाय): ₹66 प्रति ली"
    case milkRateNoteFor66 = "***  01/05/2024 से दूध का रेट  *** \n₹66 प्रति ली"
   
//    case milkRateNoteFor70 = "   ***  01/05/2024 से दूध का रेट  *** \n(भैंस): ₹70 प्रति ली  |  (गाय): ₹66 प्रति ली"
//    case milkRateNoteFor66 = "   ***  01/05/2024 से दूध का रेट  *** \n                     ₹66 प्रति ली"
    case NotePoint2 = "2) उधार दूध लेने की स्थिति में 7 तारीख तक भुगतान करना अनिवार्य है ।"
    case NotePoint1 = "1) दूध डिलीवरी बॉय को भुगतान(रुपये) देते समय हमें फोन द्वारा सूचित करें अन्यथा आपकी जिम्मेदारी होगी ।"
    case MobileNumber1 = "9897303731"
    case MobileNumber2 = "9358291888"
    
    var value : String {
        return self.rawValue
    }
}

enum IPadPaperDimensions : CGFloat {
    case PaperWidth = 285
    case PaperHeight = 420
    case BorderWidth = 2
    case marginFromBothSides = 8

    var value : CGFloat {
        return self.rawValue
    }
}

enum PaperDimensions : CGFloat {
    case PaperWidth = 188
    case PaperHeight = 360
    case BorderWidth = 2
    case marginFromBothSides = 8

    var value : CGFloat {
        return self.rawValue
    }
}

enum CustomerDataKeys : String {
    case CustomerName = "CustomerName"
    case TotalBuffaloMilk = "TotalBuffaloMilk"
    case TotalCowMilk = "TotalCowMilk"
    case SNo = "SNo."
    case NormalMilkRate = "NormalMilkRate"
    case PackingMilkRate = "PackingMilkRate"
    case Balance = "Balance"
    case Advance = "Advance"
    case isPackingMilk = "isPackingMilk"
    case FinalAmt = "Final Amt"
    
    var value : String {
        return self.rawValue
    }
}

enum MilkRates  : Double {
    case NormalMilkRate =  66
    case BuffaloPackingMilkRate = 70
    var value : Double {
        return self.rawValue
    }
}


enum MilkRatesInString  : String {
    case NormalMilkRate =  "66"
    case BuffaloPackingMilkRate = "70"
    var value : String {
        return self.rawValue
    }
}
