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
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("granted notification")
            }
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

extension LocalNotificationManager {
    func prepareFor(task: Task) -> [UUID] {
        let notifications: [Notification] = []

        LocalNotificationManager.sharedInstance.schedule(notifications: notifications)
        
        return notifications.map { $0.id }
    }
    
    func removeFor(task: Task) {
        deschedule(identifiers: task.notifcationsIdentifiers)
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
