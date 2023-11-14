//
//  ViewExtensions.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 27/08/23.
//

import Foundation
import UIKit

//Add Shadow to View
extension UIView {
    func dropShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }
}



//Extension to get the TopViewController
extension NSObject {
    var topMostViewController : UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.last
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                return topController
            }
            if let navVC = topController as? UINavigationController {
                if !navVC.viewControllers.isEmpty {
                    return  navVC.viewControllers.last
                }
                return topController
            }
            return topController
        }
        return nil
    }
}


extension String {
    func trim() -> String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
}
