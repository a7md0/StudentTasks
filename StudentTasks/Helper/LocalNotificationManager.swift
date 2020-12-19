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
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init() { } // Private constructor (this class cannot be initlized from the outside)
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("granted notification")
            }
        }
    }
    
    func scheduleNotification(notification: Notification) {
        let content = constructContent(notification)
        let triggerDate: DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notification.triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: notification.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }
            print("Scheduling notification with id: \(notification.id)")
        }
    }
    
    private func constructContent(_ notification: Notification) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = notification.title
        if let body = notification.body {
            content.body = body
        }
        if let subtitle = notification.subtitle {
            content.subtitle = subtitle
        }
        
        content.sound = notification.sound
        content.badge = NSNumber(value: notification.badge)
        
        if let userInfo = notification.userInfo {
            content.userInfo = userInfo
        }
        
        return content
    }
}
