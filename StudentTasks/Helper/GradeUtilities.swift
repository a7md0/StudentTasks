//
//  GradeUtilities.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/2/21.
//

import Foundation

struct GradeUtilities {
    static var percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    static func forPlusMapper(grade: Decimal) -> String? {
        switch (grade * 100) {
        case 0..<60:
            return "F"
        case 60..<70:
            return "D"
        case 70..<80:
            return "C"
        case 80..<90:
            return "B"
        case 90...100:
            return "A"
        default:
            return nil
        }
    }
    
    static func forPlusMinusMapper(grade: Decimal) -> String? {
        switch (grade * 100) {
        case 0..<60:
            return "F"
        case 60..<65:
            return "C"
        case 65..<70:
            return "C+"
        case 70..<75:
            return "B-"
        case 75..<80:
            return "B"
        case 80..<85:
            return "B+"
        case 85..<90:
            return "A-"
        case 90..<95:
            return "A"
        case 95...100:
            return "A+"
        default:
            return nil
        }
    }
}
