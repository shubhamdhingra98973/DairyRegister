//
//  DairySlipConstants.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 04/05/24.
//

import Foundation
enum DairySlipsContants : String {
    
    case BusinessName = "ओम साईं राम डेयरी फार्म"
    case MainBusinesName  = "पप्पू डेयरी फार्म"
    case Datee = "दिनाक"
    case Area = "क्षेत्र"
    case VijayNagar = "विजय नगर"
    case kamlaNagar = "कमला नगर"
    case Karamyogi = "कर्मयोगी"
    case morning = "सुबह"
    case evening = "शाम"
    case Address  = "कमला नगर, आगरा"
    case CustomerName = "ग्राहक का नाम"
    case SerialNo = "क्रमांक"
    case Milk = "दूध"
    case Total = "कुल"
    case rupees = "₹"
    case buffalo = "भैंस"
    case cow = "गाय"
    case kullLitre = "कुल (लीटर)"
    case OneLitPacket = "1 ली पैकेट            :"
    case halfLitPacket = "1/2 ली पैकेट        :"
   
    var value : String {
        return self.rawValue
    }
}
