//
//  BillCreation.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 27/08/23.
//

import Foundation
import UIKit

class BillCreation : NSObject {
    
    static let shared = BillCreation()
    
    private override init () {
        
    }
    
    func getBill(_ customerRecord : [String : Any]) -> UIImage? {
        // Text content
        let kBusinessNameText = BillConstants.BusinessName.value
        let kBusinessLocationText = BillConstants.Address.value
        var yCordinate : CGFloat = 0
        let data = customerRecord
        // Image dimensions
        let paperWidth = Utility.shared.isiPad() ? IPadPaperDimensions.PaperWidth.value : PaperDimensions.PaperWidth.value
        let paperHeight =  Utility.shared.getPaperHeight(data: data)
        print("paperHeight Calculated :",paperHeight)
        let imageSize = CGSize(width:  paperWidth, height: paperHeight)
        let isIPadDevice = Utility.shared.isiPad()
        
        // Create a blank image context
//        UIGraphicsBeginImageContext(imageSize)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            fatalError("Unable to get image context")
//        }
//        print("Context :",context)
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        //Setting Background color to paper
        let image = renderer.image { context in
            let drawRect = CGRect(x: 0,y: yCordinate,width: imageSize.width,height: imageSize.height)
            UIColor.white.setFill()
            UIRectFill(drawRect)
            context.fill(CGRect(origin: .zero, size: CGSize(width: imageSize.width, height: imageSize.height)))
            
            
            UIColor.black.setStroke()
            let borderRect = CGRect(x: 0, y: yCordinate, width: imageSize.width, height: imageSize.height)
            context.cgContext.stroke(borderRect, width: 1)
            
            
            yCordinate =  yCordinate.setTopMargin(value: 2)
            addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize24 : .BoldSize16, text: kBusinessNameText, yCordinate: yCordinate)
            yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 24 : 14)
            addTextInCenter(context:  context.cgContext, font: .RegularSize10, text: kBusinessLocationText, yCordinate: yCordinate)
            yCordinate = yCordinate.setTopMargin(value: 14)
            addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
            yCordinate = yCordinate.setTopMargin(value: 4)
            
            if let serialNo = data["SNo."] {
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .RegularSize16 : .RegularSize10, text: "\(BillConstants.SerialNo.value) : ", yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value)
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize10, text: "\(serialNo)", yCordinate: yCordinate , alignment: .left , marginFromLeft: isIPadDevice ? 60 : 40)
            }
            if let month = data["Month"] as? String , let monthInt = Int(month) {
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize10, text: "\(Utility.shared.getMonthText(monthNumber: monthInt)) \(Utility.shared.getCurrentYear())", yCordinate: yCordinate , alignment: .right , marginFromLeft: 0 , marginFromRight: PaperDimensions.marginFromBothSides.value)
            }
            yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 24 : 16)
            addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
            
            yCordinate =  yCordinate.setTopMargin(value: 4)
            if let customerName = data["CustomerName"] {
                let customerNameTextRect : CGFloat = isIPadDevice ? 100 : 58
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .RegularSize16 : .RegularSize10, text: "\(BillConstants.CustomerName.value) : ", yCordinate: yCordinate , alignment: .left , marginFromLeft:  PaperDimensions.marginFromBothSides.value , textContainerWidth: customerNameTextRect)
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize12, text: "\(customerName)", yCordinate: yCordinate - 1  , alignment: .left , marginFromLeft: customerNameTextRect + 12  , textContainerWidth: paperWidth - CGFloat(customerNameTextRect))
                let lineTakenByContent = Utility.shared.noOfLinesTakenByContent(text: "\(customerName)", font: .BoldSize12, contentArea: CGSize(width: paperWidth - CGFloat(customerNameTextRect), height: paperHeight))
                let yMarginSpacing : CGFloat = isIPadDevice ? 24 : 16
                yCordinate =  yCordinate.setTopMargin(value: CGFloat(lineTakenByContent) * yMarginSpacing)
                addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
            }
            
            yCordinate =  yCordinate.setTopMargin(value: 4)
            addMultipleContentInaRow(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize10, leftContent: BillConstants.Milk.value, centerContent: BillConstants.kullLitre.value, rightContent: BillConstants.TotalInRupees.value, marginFromLeft:  PaperDimensions.marginFromBothSides.value , marginFromRight: PaperDimensions.marginFromBothSides.value, yCordinate: yCordinate , fonts: isIPadDevice ? [.BoldSize14 , .BoldSize14 , .BoldSize14] : [.BoldSize12 , .BoldSize12 , .BoldSize12])
            
            yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 24 : 20)
            addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
            
            let CowMilkTotalAmount = BillManager.shared.calculateTotalCowMilkAmount(data: data)
            let BuffaloMilkTotalAmount =  BillManager.shared.calculateTotalBuffaloMilkAmount(data: data)
            let totalMonthlyAmount = CowMilkTotalAmount + BuffaloMilkTotalAmount
            print("Calculate Cow Milk Amount :",CowMilkTotalAmount)
            print("Calculate Buffalo Milk Amount :",BuffaloMilkTotalAmount)
            print("******* Total Monthly Amount :",totalMonthlyAmount)
            var haveBuffaloMilk = false
            if let buffaloMilk = data["TotalBuffaloMilk"] , (buffaloMilk as? String) != "0"{
                yCordinate =  yCordinate.setTopMargin(value: 8)
                haveBuffaloMilk = true
                addMultipleContentInaRow(context:  context.cgContext, font:  isIPadDevice ?  .RegularSize14 : .RegularSize12, leftContent: BillConstants.buffalo.value, centerContent: "\(buffaloMilk)  ली", rightContent: "\(BillConstants.rupees.value)\(Int(BuffaloMilkTotalAmount))", marginFromLeft:  PaperDimensions.marginFromBothSides.value , marginFromRight: PaperDimensions.marginFromBothSides.value, yCordinate: yCordinate , fonts: isIPadDevice ? [.RegularSize14 , .BoldSize14 , .BoldSize14] : [.RegularSize12 , .BoldSize12 , .BoldSize12])
            }
            
            if let cowMilk = data["TotalCowMilk"] , (cowMilk  as? String) != "0"{
                yCordinate =  yCordinate.setTopMargin(value: haveBuffaloMilk ? 20 : 8)
                addMultipleContentInaRow(context:  context.cgContext, font: isIPadDevice ?  .RegularSize14 : .RegularSize12, leftContent: BillConstants.cow.value, centerContent: "\(cowMilk)  ली", rightContent: "\(BillConstants.rupees.value)\(Int(CowMilkTotalAmount))", marginFromLeft:  PaperDimensions.marginFromBothSides.value , marginFromRight: PaperDimensions.marginFromBothSides.value, yCordinate: yCordinate , fonts: isIPadDevice ? [.RegularSize14 , .BoldSize14 , .BoldSize14] : [.RegularSize12 , .BoldSize12 , .BoldSize12])
                
            }
            yCordinate =  yCordinate.setTopMargin(value:  isIPadDevice ? 24 : 20)
            addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
            yCordinate =  yCordinate.setTopMargin(value: 10)
            
            //Total Monthly Amount
            let totalMontlyAmountTextRect : CGFloat = Utility.shared.isiPad() ? 185 : 120
            addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .RegularSize14 : .RegularSize10, text: "\(BillConstants.totalMontlyAmount.value)", yCordinate: yCordinate , alignment: .left , marginFromLeft:  PaperDimensions.marginFromBothSides.value,marginFromRight:  PaperDimensions.marginFromBothSides.value , textContainerWidth: totalMontlyAmountTextRect)
            addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize12, text: "\(BillConstants.rupees.value)\(Int(totalMonthlyAmount))", yCordinate: yCordinate - 1  , alignment: .right , marginFromLeft: totalMontlyAmountTextRect  , textContainerWidth: paperWidth / 3)
            
            yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 24 : 20)
            
            if let balance = data["Balance"] {
                if ((balance as? String) != "0") {
                    let totalBalanceTextRect : CGFloat = Utility.shared.isiPad() ? 185 : 120
                    addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .RegularSize14 :  .RegularSize10, text: "\(BillConstants.balanceAmount.value)", yCordinate: yCordinate , alignment: .left , marginFromLeft:  PaperDimensions.marginFromBothSides.value,marginFromRight:  PaperDimensions.marginFromBothSides.value , textContainerWidth: totalBalanceTextRect)
                    addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize12, text: "\(BillConstants.rupees.value)\(Int( BillManager.shared.convertValueToDouble(balance)))", yCordinate: yCordinate - 1  , alignment: .right , marginFromLeft: totalBalanceTextRect  , textContainerWidth: paperWidth / 3)
                    
                    yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 24 : 20)
                }
            }
            
            
            
            if let advance = data["Advance"]  {
                if ((advance as? String) != "0") {
                    let totalAdvanceTextRect : CGFloat = Utility.shared.isiPad() ? 185 : 120
                    addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .RegularSize14 :  .RegularSize10, text: "\(BillConstants.AdvanceAmount.value)", yCordinate: yCordinate , alignment: .left , marginFromLeft:  PaperDimensions.marginFromBothSides.value,marginFromRight:  PaperDimensions.marginFromBothSides.value , textContainerWidth: totalAdvanceTextRect)
                    addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize12, text: "\(BillConstants.rupees.value)\(Int( BillManager.shared.convertValueToDouble(advance)))", yCordinate: yCordinate - 1  , alignment: .right , marginFromLeft: totalAdvanceTextRect  , textContainerWidth: paperWidth / 3)
                    yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 24 : 20)
                }
                
            }
            
            addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
            yCordinate =  yCordinate.setTopMargin(value: 5)
            
            
            //Final Payable Amount
            let finalPayableAmount = BillManager.shared.getFinalPayableAmount(data: data, totalMontlyAmount: totalMonthlyAmount)
            addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize20 : .BoldSize14, text: "\(BillConstants.finalPayableAmount.value)", yCordinate: yCordinate , alignment: .left , marginFromLeft:  PaperDimensions.marginFromBothSides.value,marginFromRight:  PaperDimensions.marginFromBothSides.value , textContainerWidth: totalMontlyAmountTextRect)
            addTextInCenter(context:  context.cgContext, font:  isIPadDevice ?.BoldSize20 : .BoldSize14, text: "\(BillConstants.rupees.value)\(Int(finalPayableAmount))", yCordinate: yCordinate - 1  , alignment: .right , marginFromLeft: totalMontlyAmountTextRect  , textContainerWidth: paperWidth / 3)
            yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 30 : 20)
            addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
            yCordinate =  yCordinate.setTopMargin(value: 10)
            
            
            
            /****          NOTE  POINTS        ******/
            
            addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize10, text: BillConstants.Note.value, yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value)
            yCordinate =  yCordinate.setTopMargin(value: 16)
            let finalNoteContent =  "\(BillConstants.NotePoint1.value)"
            addTextInCenter(context:  context.cgContext, font:  isIPadDevice ? .RegularSize14 : .RegularSize10, text: finalNoteContent, yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value, marginFromRight: PaperDimensions.marginFromBothSides.value)
            let lineTakenByContent = Utility.shared.noOfLinesTakenByContent(text: finalNoteContent, font: .BoldSize12, contentArea: CGSize(width:paperWidth, height: paperHeight))
            let yMarginSpacing : CGFloat = isIPadDevice ? 12 : 10
            yCordinate =  yCordinate.setTopMargin(value: CGFloat(lineTakenByContent) * yMarginSpacing)
            let mobileContent =  "\(BillConstants.MobileNumber1.value) , \(BillConstants.MobileNumber2.value)"
            addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize10, text: mobileContent, yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value , marginFromRight: PaperDimensions.marginFromBothSides.value)
            yCordinate =  yCordinate.setTopMargin(value: 20)
            addTextInCenter(context:  context.cgContext, font:  isIPadDevice ? .RegularSize14 : .RegularSize10, text: BillConstants.NotePoint2.value, yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value , marginFromRight: PaperDimensions.marginFromBothSides.value)
            
        }
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        return image
    }
    
    
    func addDashedLine(context : CGContext , yCordinate :CGFloat){
        // Draw the dashed line
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineDash(phase: 0, lengths: [6.0, 1.0])
        context.setLineWidth(1.0)
        let dashedLineStart = CGPoint(x: 0, y: yCordinate)
        let dashedLineEnd = CGPoint(x: Utility.shared.isiPad() ? IPadPaperDimensions.PaperWidth.value : PaperDimensions.PaperWidth.value, y: yCordinate)
        
        context.move(to: dashedLineStart)
        context.addLine(to: dashedLineEnd)
        context.strokePath()
        
    }
    
    func addTextInCenter(context : CGContext , font : FontFamilyAndSize , text : String  , yCordinate : CGFloat , alignment : NSTextAlignment = .center , marginFromLeft : CGFloat = 0 , marginFromRight : CGFloat = 0 , textContainerWidth : CGFloat  = Utility.shared.isiPad() ? IPadPaperDimensions.PaperWidth.value : PaperDimensions.PaperWidth.value , textContainerHeight : CGFloat  = PaperDimensions.PaperHeight.value){
        
        // Set text attributes
        let textFont = Utility.shared.getFont(fontInfo: font)
        let textColor = UIColor.black
        let textRect = CGRect(x: marginFromLeft, y: yCordinate, width: textContainerWidth - marginFromRight, height:  textContainerHeight)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        // Draw the text on the image
        text.draw(in: textRect, withAttributes: textAttributes)
        
    }
    
    
    
    
    
    func addMultipleContentInaRow(context : CGContext , font : FontFamilyAndSize , leftContent : String , centerContent : String , rightContent : String , marginFromLeft : CGFloat = 0 , marginFromRight : CGFloat = 0 ,yCordinate : CGFloat , textContainerWidth : CGFloat  = Utility.shared.isiPad() ? IPadPaperDimensions.PaperWidth.value : PaperDimensions.PaperWidth.value , textContainerHeight : CGFloat  = PaperDimensions.PaperHeight.value , fonts : [FontFamilyAndSize] = [ .RegularSize12 ,.RegularSize12 , .RegularSize12])  {
        
        let LeftParagraphStyle = NSMutableParagraphStyle()
        LeftParagraphStyle.alignment = .left
        
        let CenterParagraphStyle = NSMutableParagraphStyle()
        CenterParagraphStyle.alignment = .center
        
        let RightParagraphStyle = NSMutableParagraphStyle()
        RightParagraphStyle.alignment = .right
        
        let textColor = UIColor.black
        let LeftTextAttributes: [NSAttributedString.Key: Any] = [
            .font: Utility.shared.getFont(fontInfo: fonts[0]),
            .foregroundColor: textColor,
            .paragraphStyle: LeftParagraphStyle
        ]
        
        let CenterTextAttributes: [NSAttributedString.Key: Any] = [
            .font: Utility.shared.getFont(fontInfo: fonts[1]),
            .foregroundColor: textColor,
            .paragraphStyle: CenterParagraphStyle
        ]
        
        let RightTextAttributes: [NSAttributedString.Key: Any] = [
            .font: Utility.shared.getFont(fontInfo: fonts[2]),
            .foregroundColor: textColor,
            .paragraphStyle: RightParagraphStyle
        ]
        
        
        let subContainerWidth = textContainerWidth / 3
        let subContainerHeight = textContainerHeight / 3
        // Set text attributes
        let leftTextRect = CGRect(x: marginFromLeft, y: yCordinate, width: subContainerWidth, height:  subContainerHeight)
        let centerTextRect = CGRect(x: 0 + subContainerWidth, y: yCordinate, width: subContainerWidth, height:  subContainerHeight)
        let rightTextRect = CGRect(x: 0 + subContainerWidth * 2, y: yCordinate, width: subContainerWidth - marginFromRight, height:  subContainerHeight)
        
        // Draw the text on the image
        leftContent.draw(in: leftTextRect, withAttributes: LeftTextAttributes)
        centerContent.draw(in: centerTextRect, withAttributes: CenterTextAttributes)
        rightContent.draw(in: rightTextRect, withAttributes: RightTextAttributes)
    }
}
