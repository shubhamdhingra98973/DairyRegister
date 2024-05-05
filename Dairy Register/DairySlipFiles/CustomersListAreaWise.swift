//
//  CustomersListAreaWise.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 04/05/24.
//

import Foundation


class CustomersListAreaWise : NSObject {
    
    
    static let shared = CustomersListAreaWise()
    
    private override init () {
        
    }
    
    
    func vijayNagarCustomersListWithMilk() -> [[String : Any]]{
        
        let customerList = [
        ["name" : "राजेश","milk" : "1"],
        ["name" : "आशीष","milk" :"2"],
        ["name" : "104","milk" : "1"],
        ["name" : "खन्ना","milk" : "1.5"],
        ["name" : "राजीव","milk" : "0.5"],
        ["name" : "नीरज","milk" : "1.5"],
        ["name" : "मनोज","milk" : "4"],
        ["name" : "नरेश","milk" : "4"],
        ["name" : "सुधीर","milk" : ""],
        ["name" : "दिनेश बंसल","milk" : "2"],
        ["name" : "ज्ञानचंद","milk" : "2"],
        ["name" : "302 पूनम","milk" : "2"],
        ["name" : "201 अर्पित","milk" : "1.5"],
        ["name" : "605 मनोज","milk" : "3"],
        ["name" : "प्रह्लाद","milk" : "1"],
        ["name" : "शिव कुमार","milk" : "2"],
        ["name" : "अनिल अग्रवाल","milk" : ""],
        ]
        return customerList
        
    }
    
    func kamlaNagarEvenCustList() -> [[String : Any]]{
        
        let customerList = [
        ["name" : "सुपारी No 41","milk" : ""],
        ["name" : "राजेंद्र","milk" :"1.5"],
        ["name" : "हरिओम","milk" : "1.5"],
        ["name" : "टावर 102","milk" : "1.5"],
        ["name" : "टावर 105","milk" : "1.5"],
        ["name" : "टावर 304","milk" : "4"],
        ["name" : "टावर 305","milk" : "1.5"],
        ["name" : "टावर 408","milk" : "1"],
        ["name" : "F-64","milk" : "2"],
        ["name" : "रमन (ऊपर)","milk" : "2"],
        ["name" : "रमन (नीचे)","milk" : ""],
        ["name" : "मुनीम जी (बालकेश्वर)","milk" : "1"],
        ["name" : "फ्रिज वाले","milk" : "1.5"],
        ["name" : "F-37","milk" : "1"],
        ["name" : "D-158","milk" : "2"],
        ["name" : "F-103","milk" : "1.5"],
        ["name" : "संजय शर्मा","milk" : "2"],
        ]
        return customerList
        
    }
    
    func karamyogiEvenCustomerList() -> [[String : Any]]{
        
        let customerList = [
        ["name" : "भरत","milk" : "1"],
        ["name" : "डॉ एस सी","milk" :""],
        ["name" : "दीपक अग्रवाल","milk" : "3"],
        ["name" : "राहुल","milk" : "1.5"],
        ["name" : "कमल","milk" : "1"],
        ["name" : "I-2","milk" : "1"],
        ["name" : "I-3","milk" : "1"],
        ["name" : "अमित बंसल","milk" : "2.5"],
        ["name" : "R-14 कमल","milk" : "1"],
        ["name" : "R-38","milk" : "1"],
        ["name" : "G-6 विनोद","milk" : "1.5"],
        ["name" : "G-7 हरीश","milk" : "1"],
        ["name" : "G-13 विजय","milk" : "3.5"],
        ["name" : "G-16 संतोष","milk" : "1"],
        ["name" : "M-2","milk" : "2"],
        ["name" : "M-5(ऊपर)","milk" : "3"],
        ["name" : "M-5(नीचे)","milk" : "1.5"],
        ["name" : "आर पी कविशा","milk" : "1.5"],
        ["name" : "अशोक मुलानी","milk" : "2"],
        ["name" : "पायल","milk" : "1"],
        ["name" : "सुनील (टेंट वाले)","milk" : "2"],
        ["name" : "हितेश अरोड़ा","milk" : ""],
        ["name" : "सुनील चावला","milk" : "2"],
        ["name" : "राजू चावला","milk" : "2"],
        ["name" : "बंसल","milk" : "2.5"],
        ["name" : "राकेश जैन","milk" : "1"],
        ["name" : "अनुज जैन","milk" : "2"],
        ["name" : "विष्णु","milk" : "1"],
        ["name" : "A-29 इशिता","milk" : "1"],
        ["name" : "विवेक","milk" : "1"],
        ]
        return customerList
        
    }
    
    
    func kamlaNagarMornCustomerListPage1() -> [[String : Any]]{
        
        let customerList = [
        ["name" : "D-86 गोविंद","milk" : "1.5"],
        ["name" : "E-737 हरीश","milk" :"1.5"],
        ["name" : "यश मेडिकल","milk" : "1.5"],
        ["name" : "मुल्तान पेंट","milk" : "1"],
        ["name" : "राजेन्द्र प्रसाद","milk" : "1.5"],
        ["name" : "दिलीप धनानी","milk" : "2"],
        ["name" : "K-90 संजय","milk" : ""],
        ["name" : " K-90 मनीष","milk" : ""],
        ["name" : "रवि जैन","milk" : "1.5"],
        ["name" : "सुरेंद्र नाथ","milk" : "1.5"],
        ["name" : "D-18","milk" : "1"],
        ["name" : "सुबोध गोयल","milk" : "2.5"],
        ["name" : "No-17","milk" : "1"],
        ["name" : "काली भाई","milk" : "2.5"],
        ["name" : "A-17 उमेश","milk" : "1.5"],
        ["name" : "A-18 दिलीप","milk" : "2"],
        ["name" : "नंदलाल","milk" : "3"],
        ["name" : "त्रिलोकी","milk" : "1"],
        ["name" : "D-506 (ऊपर)","milk" : "1"],
        ["name" : "D-506 (नीचे)","milk" : "1.5"],
        ["name" : "मनीष","milk" : "1"],
        ]
        return customerList
        
    }
    
    func kamlaNagarMornCustomerListPage2() -> [[String : Any]]{
        let customerList = [
                    ["name" : "सुपारी No 41","milk" : ""],
                    ["name" : "45 (ऊपर)","milk" : ""],
                    ["name" : "45 (नीचे)","milk" : ""],
                    ["name" : "47 (ऊपर)","milk" : ""],
                    ["name" : "47 (नीचे)","milk" : ""],
                    ["name" : "हरिओम","milk" : "1"],
                    ["name" : "गर्ग","milk" : "2"],
                    ["name" : "रमन (ऊपर)","milk" : "1"],
                    ["name" : "रमन (नीचे)","milk" : "2.5"],
                    ["name" : "भगत जी","milk" : ""],
                    ["name" : "ललित मल्होत्रा","milk" : ""],
                    ["name" : "गौरव गुप्ता","milk" : "2"],
        ]
        return customerList
    }
}
