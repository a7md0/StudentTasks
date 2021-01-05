//
//  UIColor + Hex.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/5/21.
//

import Foundation
import UIKit

/*
 Source: https://stackoverflow.com/a/32523136/1738413
 Author: Suragch
 */
extension UIColor {
    convenience init(hexadecimal: Int) {
        let red =   CGFloat((hexadecimal & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((hexadecimal & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(hexadecimal & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
