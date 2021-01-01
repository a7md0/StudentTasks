//
//  AppearanceSettings.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/1/21.
//

import Foundation
import UIKit

struct AppearanceSettings: Codable {
    private static let saveKey: String = "appearanceSettings"
    
    var theme: AppearanceTheme = .system
}

enum AppearanceTheme: String, Codable, CaseIterable {
    case system = "System", light = "Light", dark = "Dark"
}

extension AppearanceTheme {
    static func interfaceStyleOf(_ theme: AppearanceTheme) -> UIUserInterfaceStyle {
        switch theme {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

extension AppearanceTheme: CustomStringConvertible, Equatable {
    public var description: String {
        switch self {
        case .system:
            return "System theme"
        case .light:
            return "Light theme"
        case .dark:
            return "Dark theme"
        }
    }
    
    static func == (lhs: AppearanceTheme, rhs: AppearanceTheme) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static func == (lhs: UIUserInterfaceStyle, rhs: AppearanceTheme) -> Bool {
        switch lhs {
        case .unspecified:
            return rhs == .system
        case .light:
            return rhs == .light
        case .dark:
            return rhs == .dark
        default:
            return false
        }
    }
}

extension AppearanceSettings {
    func update() {
        if self.save() {
            DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
                NotificationCenter.default.post(name: Constants.appearanceSettingsNotifcations["updated"]!, object: self)
            }
        }
    }
    
    private func save() -> Bool {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.setValue(data, forKey: AppearanceSettings.saveKey)
            
            return true
        }
        
        return false
    }
    
    static func load() -> AppearanceSettings {
        if let data = UserDefaults.standard.data(forKey: AppearanceSettings.saveKey),
           let appearanceSettings = try? JSONDecoder().decode(AppearanceSettings.self, from: data) {
            return appearanceSettings
        }
        
        return AppearanceSettings()
    }
    
    static func reset() -> AppearanceSettings {
        let appearanceSettings = AppearanceSettings()
        appearanceSettings.update()
                
        return appearanceSettings
    }
}
