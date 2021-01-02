//
//  NotificationSettings.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/30/20.
//

import Foundation

struct NotificationSettings: Codable {
    private static let saveKey: String = "notificationSettings"
    
    var notificationsGranted: Bool = false
    var notificationsEnabled: Bool = true
    
    var triggerBefore: Double = 3
    
    var preferredTypes: [TaskType] = TaskType.allCases
    var preferredPriorities: [TaskPriority] = TaskPriority.allCases
    
    var preferredTimeRange: DateInterval = DateInterval(start: Constants.notifcationFromTime, end: Constants.notifcationToTime)
}

extension NotificationSettings {
    func update() {
        if self.save() {
            DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
                NotificationCenter.default.post(name: Constants.notifcationSettings["updated"]!, object: self)
            }
        }
    }
    
    func save() -> Bool {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.setValue(data, forKey: NotificationSettings.saveKey)
            
            return true
        }
        
        return false
    }
    
    mutating func switchGrant(granted: Bool) {
        self.notificationsGranted = granted
        
        if !granted {
            notificationsEnabled = false
        }
        
        if self.save() {
            let settings = self
            DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
                NotificationCenter.default.post(name: Constants.notifcationSettings["enabledChanged"]!, object: settings)
            }
        }
    }
    
    static func load() -> NotificationSettings {
        if let data = UserDefaults.standard.data(forKey: NotificationSettings.saveKey),
           let notificationSettings = try? JSONDecoder().decode(NotificationSettings.self, from: data) {
            return notificationSettings
        }
        
        return NotificationSettings()
    }
    
    static func reset() -> NotificationSettings {
        let notificationSettings = NotificationSettings()
        notificationSettings.update()
        
        LocalNotificationManager.sharedInstance.detectPermission(callback: nil)
        
        return notificationSettings
    }
}
