//
//  Grade.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/2/21.
//

import Foundation

struct TaskGrade: Codable {
    var graded: Bool = false
    var mode: GradeMode = .percentage

    var contribution: Decimal?
    //var contributeTo: ContributionType?
    
    
    var grade: Decimal?
}

extension TaskGrade {
    var formattedGrade: String {
        var formatted: String?
        
        if let grade = self.grade {
            let gradingSettings = GradingSettings.instance
            
            switch gradingSettings.gpaModel {
            case .fourPlus:
                formatted = GradeUtilities.forPlusMapper(grade: grade)
            case .fourPlusMinus:
                formatted = GradeUtilities.forPlusMinusMapper(grade: grade)
            case .hundredPercentage:
                formatted = GradeUtilities.percentageFormatter.string(for: grade)
            }
        }
        
        return formatted ?? "-"
    }
}

enum GradeMode: String, Codable, CustomStringConvertible {
    case percentage = "Percentage", fraction = "Fraction"
    
    var description: String {
        switch self {
        case .percentage:
            return NSLocalizedString("Percentage", comment: "Percentage")
        case .fraction:
            return NSLocalizedString("Fraction", comment: "Fraction")
        }
    }
}

/*enum ContributionType: String, Codable, CaseIterable, CustomStringConvertible {
    var description: String {
        switch self {
        case .courseTotal:
            return "Course Total"
        case .mainTask:
            return "Main task"
        }
    }
    
    case courseTotal = "Course Total", mainTask = "Main Task"
}*/
