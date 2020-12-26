//
//  Notification.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/19/20.
//

import Foundation
import UserNotifications

struct Notification {
    var id: UUID = UUID()
    
    var content = UNMutableNotificationContent()
    var triggerDate: Date
    
    var dateMatching: DateComponents {
        return Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: self.triggerDate)
    }
    
    func sechudle() {
        LocalNotificationManager.sharedInstance.scheduleNotification(notification: self)
    }
}
