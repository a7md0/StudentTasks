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
    
    func scheduleNotification(notification: Notification) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateMatching, repeats: false)
        let request = UNNotificationRequest(identifier: notification.id.uuidString, content: notification.content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            guard error == nil else { return }
            print("Scheduling notification with id: \(notification.id)")
        }
    }
    
    func descheduleNotification(identifier: UUID) {
        self.descheduleNotifications(identifiers: [identifier])
    }
    
    func descheduleNotifications(identifiers: [UUID]) {
        let stringIdentifiers = identifiers.map { $0.uuidString }
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: stringIdentifiers)
    }
}
