//
//  PromptHelper.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/6/21.
//

import Foundation
import UIKit

struct PromptHelper {
    static func promptText(title: String, message: String, placeholder: String, value: String?, callback: ((String?) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var textField: UITextField!
        
        alert.addTextField { (alertText) in
            alertText.placeholder = placeholder
            alertText.text = value ?? ""
            
            alertText.keyboardType = .numbersAndPunctuation
                        
            textField = alertText
        }
        
        alert.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { alert in
            callback?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { alert in
            callback?(textField.text)
        }))
        
        return alert
    }
}
