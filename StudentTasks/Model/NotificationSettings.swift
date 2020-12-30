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
    
    var preferredTypes: [TaskType] = TaskType.allCases
    var preferredPriorities: [TaskPriority] = TaskPriority.allCases
    
    var preferredTimeRange: DateInterval = DateInterval(start: Constants.notifcationFromTime, end: Constants.notifcationToTime)
}

extension NotificationSettings {
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.setValue(data, forKey: NotificationSettings.saveKey)
            
            DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
                NotificationCenter.default.post(name: Constants.notifcationSettings["updated"]!, object: self)
            }
        }
    }
    
    mutating func switchGrant(granted: Bool) {
        self.notificationsGranted = granted
        
        if !granted {
            notificationsEnabled = false
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
        notificationSettings.save()
        
        LocalNotificationManager.sharedInstance.detectPermission(callback: nil)
        
        return notificationSettings
    }
}
