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
    static var instance: NotificationSettings = load()
    
    func update() {
        if self.save() {
            DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
                NotificationCenter.default.post(name: Constants.notifcationSettings["updated"]!, object: self)
            }
        }
    }
    
    private func save() -> Bool {
        NotificationSettings.instance = self
        
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.setValue(data, forKey: NotificationSettings.saveKey)
            print("save notification settings: \(self)")
            
            return true
        }
        
        return false
    }
    
    private func notifyEnabledChanged(object: Any) {
        DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
            NotificationCenter.default.post(name: Constants.notifcationSettings["enabledChanged"]!, object: object)
        }
    }
    
    mutating func switchEnabled(on: Bool) {
        print("switchEnabled: \(notificationsEnabled) -> \(on)")
        guard notificationsEnabled != on else { return }
        
        notificationsEnabled = on
                
        if self.save() {
            notifyEnabledChanged(object: self)
        }
    }
    
    mutating func switchGrant(granted: Bool) {
        print("switchGrant: \(granted)")
        guard notificationsGranted != granted else { return }
        
        self.notificationsGranted = granted
        _ = self.save()
        
        if !granted {
            switchEnabled(on: false)
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
