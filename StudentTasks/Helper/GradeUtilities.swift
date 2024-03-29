//
//  GradeUtilities.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/2/21.
//

import Foundation
import UIKit

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
    
    static func promptContribution(grade: TaskGrade, callback: ((Decimal?) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "Contribution", message: "Enter the contribution of this task to the course total (%)", preferredStyle: .alert)
        var textField: UITextField!
        let delegate = GradeTextfieldDelgate()
        
        alert.addTextField { (alertText) in
            alertText.placeholder = "30% or 25/100"
            if let contribution = grade.contribution {
                alertText.text = "\(contribution * 100)%"
            }
            
            alertText.keyboardType = .numbersAndPunctuation
            alertText.delegate = delegate
            
            textField = alertText
        }
        
        alert.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { alert in
            callback?(grade.contribution)
            delegate.dismiss(animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { alert in
            if let text = textField.text {
                var value: Decimal?
                
                if text.contains("/") {
                    let sp = text.split(separator: "/")
                    if sp.count > 1,
                       let op1 = Decimal(string: String(sp[0])),
                       let op2 = Decimal(string: String(sp[1])) {
                        
                        value = op1/op2
                    }
                } else if let percentage = GradeUtilities.percentageFormatter.number(from: text) {
                    value = percentage.decimalValue
                } else if let number = Decimal(string: text) {
                    value = number / 100
                }
                
                callback?(value)
                delegate.dismiss(animated: false, completion: nil)
            }
        }))
        
        return alert
    }
    
    static func gradePrompt(grade: TaskGrade, callback: ((GradeMode?, Decimal?) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "Grade", message: "Enter the awarded grade for this task", preferredStyle: .alert)
        var textField: UITextField!
        let delegate = GradeTextfieldDelgate()
        
        alert.addTextField { (alertText) in
            alertText.placeholder = "90% or 80/100"
            if let gradePercentage = grade.grade {
                if grade.mode == .percentage {
                    alertText.text = "\(gradePercentage * 100)%"
                } else if let gradeContribution = grade.contribution {
                    alertText.text = "\(gradePercentage * gradeContribution * 100)/\(gradeContribution * 100)"
                }
            }
            
            alertText.keyboardType = .numbersAndPunctuation
            
            alertText.delegate = delegate
            
            textField = alertText
        }
        
        alert.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { alert in
            callback?(grade.mode, grade.grade)
            delegate.dismiss(animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { alert in
            if let text = textField.text {
                var value: Decimal?
                var mode: GradeMode?
                
                if text.contains("/") {
                    let sp = text.split(separator: "/")
                    if sp.count > 1,
                       let op1 = Decimal(string: String(sp[0])),
                       let op2 = Decimal(string: String(sp[1])) {
                        
                        value = op1/op2
                        mode = .fraction
                    }
                } else if text.contains("%"),
                          let percentage = GradeUtilities.percentageFormatter.number(from: text) {
                    value = percentage.decimalValue
                    mode = .percentage
                } else if let number = Decimal(string: text) {
                    value = number / 100
                    mode = .percentage
                    
                    if let contribution = grade.contribution, number <= contribution {
                        value = number / contribution
                        mode = .fraction
                    }
                }
                
                callback?(mode, value)
                delegate.dismiss(animated: false, completion: nil)
            }
        }))
        
        return alert
    }
}

class GradeTextfieldDelgate: UIViewController, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.init(charactersIn: "0123456789./%")
        let characterSet = CharacterSet(charactersIn: string)
        
        if let text = textField.text {
            if [".", "/", "%"].contains(string), text.contains(string) {
                return false
            }
        }
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
