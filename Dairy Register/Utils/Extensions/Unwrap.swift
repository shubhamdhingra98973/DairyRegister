//
//  Unwrap.swift
//  Popeyes
//
//  Created by Shubham Dhingra on 16/06/21.
//  Copyright © 2021 Prem Prakash Chaurasia. All rights reserved.
//

import Foundation
import UIKit

//MARK: PROTOCOL
protocol OptionalType { init() }

//MARK: EXTENSIONS
extension String: OptionalType {}
extension Int: OptionalType {}
extension CGFloat: OptionalType {}
extension Double: OptionalType {}
extension Bool: OptionalType {}
extension Float: OptionalType {}
extension CGRect: OptionalType {}
extension UIImage: OptionalType {}
extension IndexPath: OptionalType {}

prefix operator /

//unwrapping values
prefix func /<T: OptionalType>( value: T?) -> T {
    guard let validValue = value else { return T() }
    return validValue
}
