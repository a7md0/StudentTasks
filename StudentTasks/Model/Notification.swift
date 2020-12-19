//
//  Notification.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/19/20.
//

import Foundation
import UserNotifications

struct Notification: Equatable {
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID()
    
    var title: String
    var subtitle: String?
    var body: String?
    
    var sound: UNNotificationSound = UNNotificationSound.default
    var badge: Int = 1
    
    var triggerDate: Date
    
    var userInfo: [AnyHashable : Any]?
    
    func sechudle() -> Void {
        LocalNotificationManager.sharedInstance.scheduleNotification(notification: self)
    }
}
