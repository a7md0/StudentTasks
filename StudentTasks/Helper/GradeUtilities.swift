//
//  GradeUtilities.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/2/21.
//

import Foundation

struct GradeUtilities {
    static func calculateOverallGradeFor(tasks: [Task]) -> Decimal? {
        var overall: Decimal?
        
        
        let grades: [TaskGrade] = tasks.map({ $0.grade })
        let contributions: Decimal = grades.reduce(0) { (contributions, taskGrade) -> Decimal in
            guard let contribution = taskGrade.contribution else { return contributions }
            
            return contributions + contribution
        }
        
        if contributions == 1.00 {
            overall = grades.reduce(0, { (overall, taskGrade) -> Decimal in
                guard let contribution = taskGrade.contribution,
                      let grade = taskGrade.grade else { return overall }
                
                return overall + (grade * contribution)
            })
        }
        
        return overall
    }
    
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
