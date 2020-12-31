//
//  GradingSettings.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/1/21.
//

import Foundation

struct GradingSettings: Codable {
    private static let saveKey: String = "gradingSettings"
    
    var gpaModel: GpaModel = .fourPlusMinus
}

extension GradingSettings {
    func update() {
        if self.save() {
            DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
                NotificationCenter.default.post(name: Constants.gradingSettingsNotifcations["updated"]!, object: self)
            }
        }
    }
    
    private func save() -> Bool {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.setValue(data, forKey: GradingSettings.saveKey)
            
            return true
        }
        
        return false
    }
    
    static func load() -> GradingSettings {
        if let data = UserDefaults.standard.data(forKey: GradingSettings.saveKey),
           let gradingSettings = try? JSONDecoder().decode(GradingSettings.self, from: data) {
            return gradingSettings
        }
        
        return GradingSettings()
    }
    
    static func reset() -> GradingSettings {
        let gradingSettings = GradingSettings()
        gradingSettings.update()
                
        return gradingSettings
    }
}

enum GpaModel: String, Codable, CaseIterable {
    case fourPlus = "4+", fourPlusMinus = "4+-", hundredPercentage = "100%"
}

extension GpaModel: CustomStringConvertible, Equatable {
    var description: String {
        switch self {
        case .fourPlus:
            return "4.0 Scale (+)"
        case .fourPlusMinus:
            return "4.0 Scale (+/-)"
        case .hundredPercentage:
            return "Percentage scale (%)"
        }
    }
}
