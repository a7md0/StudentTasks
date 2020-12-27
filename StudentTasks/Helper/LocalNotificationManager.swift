//
//  LocalNotificationManager.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/19/20.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    
    static let sharedInstance = LocalNotificationManager() // Static unimmutable variable which has instance of this class
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() { } // Private constructor (this class cannot be initlized from the outside)
    
    func requestPermission(callback: ((Bool, Error?) -> Void)?) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("granted notification")
            }
            
            callback?(granted, error)
        }
    }
    
    func schedule(notification: Notification) {
        schedule(notifications: [notification])
    }
    
    func schedule(notifications: [Notification]) {
        for notification in notifications {
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateMatching, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id.uuidString, content: notification.content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
    
    private func deschedule(identifier: UUID) {
        self.deschedule(identifiers: [identifier])
    }
    
    private func deschedule(identifiers: [UUID]) {
        let stringIdentifiers = identifiers.map { $0.uuidString }
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: stringIdentifiers)
    }
}

// MARK: Task notifications
extension LocalNotificationManager {
    func prepareFor(task: Task) -> [UUID] {
        let notifications: [Notification] = self.notificationsFor(task: task)
        
        LocalNotificationManager.sharedInstance.schedule(notifications: notifications)
        
        return notifications.map { $0.id }
    }
    
    func removeFor(task: Task) {
        deschedule(identifiers: task.notificationsIdentifiers)
    }
    
    private func notificationsFor(task: Task) -> [Notification] {
        var notifications: [Notification] = []
        
        var date1 = Date()
        date1.addTimeInterval(60)
        
        let noti1 = Notification(triggerDate: date1)
        noti1.content.title = "Test Notification"
        noti1.content.subtitle = "Aaa"
        noti1.content.body = "..............."
        noti1.content.badge = 1
        noti1.content.sound = (task.priority == .high) ? .defaultCritical : .default
        
        notifications.append(noti1)
        
        return notifications
    }
}

struct Notification {
    var id: UUID = UUID()
    
    var content = UNMutableNotificationContent()
    var triggerDate: Date
    
    var dateMatching: DateComponents {
        return Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: self.triggerDate)
    }
}
