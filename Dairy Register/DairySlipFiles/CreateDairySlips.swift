//
//  CreateDairySlips.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 04/05/24.
//

import Foundation
import UIKit

class CreateDairySlips : NSObject {
    
    static let shared = CreateDairySlips()
    
    private override init () {
        
    }
    
    func getSlipImage(slipHeight : CGFloat, isPage1 : Bool, customersListWithDailyMilk : [[String : Any]] , slipDetail : [String : Any]) -> UIImage? {
        // Text content
        let kBusinessNameText = BillConstants.BusinessName.value
        let kBusinessLocationText = BillConstants.Address.value
        var yCordinate : CGFloat = 0
        // Image dimensions
        let paperWidth = Utility.shared.isiPad() ? IPadPaperDimensions.PaperWidth.value : PaperDimensions.PaperWidth.value
        let paperHeight =  slipHeight
        print("paperHeight Calculated :",paperHeight)
        let imageSize = CGSize(width:  paperWidth, height: paperHeight)
        let isIPadDevice = Utility.shared.isiPad()
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        //Setting Background color to paper
        let image = renderer.image { context in
            
            let drawRect = CGRect(x: 0,y: yCordinate,width: imageSize.width,height: imageSize.height)
            UIColor.white.setFill()
            UIRectFill(drawRect)
//            context.fill(CGRect(origin: .zero, size: CGSize(width: imageSize.width, height: imageSize.height)))
//            
//            UIColor.black.setStroke()
//            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            
            yCordinate =  yCordinate.setTopMargin(value: 2)
            if (isPage1) {
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize24 : .BoldSize16, text: kBusinessNameText, yCordinate: yCordinate)
                yCordinate =  yCordinate.setTopMargin(value: isIPadDevice ? 24 : 14)
                addTextInCenter(context:  context.cgContext, font: .RegularSize10, text: kBusinessLocationText, yCordinate: yCordinate)
                yCordinate = yCordinate.setTopMargin(value: 14)
                addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
                yCordinate = yCordinate.setTopMargin(value: 2)
            }
           if let area = slipDetail["area"] as? String {
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize14, text: area, yCordinate: yCordinate)
                yCordinate = yCordinate.setTopMargin(value: 18)
                addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
                yCordinate = yCordinate.setTopMargin(value: 2)
            }
           
            if let datee = slipDetail["date"] as? String {
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .RegularSize16 : .RegularSize12, text: "\(DairySlipsContants.Datee.value) : ", yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value)
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize10, text: "\(datee)", yCordinate: yCordinate , alignment: .left , marginFromLeft: isIPadDevice ? 60 : 40)
            }
                
            if let timingSlot = slipDetail["timeSlot"] as? String {
                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize12, text: "(\(timingSlot))", yCordinate: yCordinate , alignment: .right , marginFromLeft: 0 , marginFromRight: PaperDimensions.marginFromBothSides.value)
            }
              
               yCordinate = yCordinate.setTopMargin(value: 18)
               addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
               yCordinate = yCordinate.setTopMargin(value: 10)
            
            print("Customer fetched Count: ",customersListWithDailyMilk.count)
            
            if (customersListWithDailyMilk.count > 0) {
                for (index , value) in customersListWithDailyMilk.enumerated() {
                    if let name = value["name"] as? String {
                        
                        if (name == "-") {
                            yCordinate = yCordinate.setTopMargin(value: 12)
                            addTotalCardAtTheBottom(context: context, yCordinate: &yCordinate, isIPadDevice: isIPadDevice)
                            yCordinate = yCordinate.setTopMargin(value: 24)
                        } else {
                            if (index > 0) {
                                yCordinate = yCordinate.setTopMargin(value: 4)
                            }
                           addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize12, text: "\(name)", yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value)
                            if let milk = value["milk"] as? String {
                                addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize14 : .BoldSize12, text: milk, yCordinate: yCordinate , alignment: .right , marginFromLeft: 0 , marginFromRight: PaperDimensions.marginFromBothSides.value)
                            }
                            yCordinate = yCordinate.setTopMargin(value: 14)
                            addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
                        }
                        
                    }
                }
                yCordinate = yCordinate.setTopMargin(value: 8)
//                addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
//                if !((slipDetail["area"] as? String) == DairySlipsContants.kamlaNagar.value && (slipDetail["timeSlot"] as? String) == DairySlipsContants.morning.value) {
                    
                    addTotalCardAtTheBottom(context: context, yCordinate: &yCordinate, isIPadDevice: isIPadDevice)
//                }
              
            }
            
        }
        return image
    }
    
    func addTotalCardAtTheBottom(context : UIGraphicsImageRendererContext , yCordinate :inout CGFloat , isIPadDevice : Bool) {
        yCordinate = yCordinate.setTopMargin(value: 24)
        BillCreation.shared.addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
        yCordinate = yCordinate.setTopMargin(value: 4)
        addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize12, text: "\(DairySlipsContants.OneLitPacket.value)", yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value)
        yCordinate = yCordinate.setTopMargin(value: 18)
        addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize12, text: "\(DairySlipsContants.halfLitPacket.value)", yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value)
        yCordinate = yCordinate.setTopMargin(value: 20)
        BillCreation.shared.addDashedLine(context:  context.cgContext, yCordinate: yCordinate)
        yCordinate = yCordinate.setTopMargin(value: 8)
        //Total :
        addTextInCenter(context:  context.cgContext, font: isIPadDevice ? .BoldSize16 : .BoldSize12, text: "\(DairySlipsContants.Total.value)", yCordinate: yCordinate , alignment: .left , marginFromLeft: PaperDimensions.marginFromBothSides.value)
    }
    
    
    func addDashedLine(context : CGContext , yCordinate :CGFloat){
        // Draw the dashed line
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineDash(phase: 0, lengths: [6.0, 2.0])
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
