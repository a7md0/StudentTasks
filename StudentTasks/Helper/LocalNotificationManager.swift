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
    private var notificationSettings: NotificationSettings = NotificationSettings.instance
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifcationStateChanged), name: Constants.notifcationSettings["enabledChanged"]!, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifcationsPreferencesUpdated), name: Constants.notifcationSettings["updated"]!, object: nil)
    } // Private constructor (this class cannot be initlized from the outside)
    
    @objc func notifcationStateChanged(notification: NSNotification) {
        guard let notificationSettings = notification.object as? NotificationSettings else { return }
        
        let tasks = Task.findAll()
        if notificationSettings.notificationsEnabled {
            _ = LocalNotificationManager.sharedInstance.prepareFor(tasks: tasks)
        } else {
            LocalNotificationManager.sharedInstance.removeFor(tasks: tasks)
        }
    }
    
    @objc func notifcationsPreferencesUpdated(notification: NSNotification) { // Notifications prefrences changes
        guard let notificationSettings = notification.object as? NotificationSettings else { return }
        
        self.notificationSettings = notificationSettings
        
        let tasks = Task.findAll() // get all tasks
        LocalNotificationManager.sharedInstance.removeFor(tasks: tasks) // deschedule notifications
        _ = LocalNotificationManager.sharedInstance.prepareFor(tasks: tasks)  // schedule notifications (which will get the newer settings)
        
    }
    
    func requestPermission(callback: ((Bool, Error?) -> Void)?) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                print("granted notification")
            }
            
            self.notificationSettings.switchGrant(granted: granted)
            
            callback?(granted, error)
        }
    }
    
    func detectPermission(ignoreNotDetermined: Bool = false, callback: ((Bool, Error?) -> Void)?) {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                if !ignoreNotDetermined {
                    self.requestPermission(callback: callback)
                }
            } else if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                if self.notificationSettings.notificationsGranted {
                    self.notificationSettings.switchGrant(granted: false)
                }
                
                callback?(false, nil)
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                if !self.notificationSettings.notificationsGranted {
                    self.notificationSettings.switchGrant(granted: true)
                }
                
                callback?(true, nil)
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
                print("Scheduling notification at \(notification.triggerDate)")
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
        return prepareFor(tasks: [task])
    }
    
    func prepareFor(tasks: [Task]) -> [UUID] {
        let notifications: [Notification] = tasks.flatMap { (task) -> [Notification] in
            return self.notificationsFor(task: task)
        }
        
        LocalNotificationManager.sharedInstance.schedule(notifications: notifications)
        
        return notifications.map { $0.id }
    }
    
    func removeFor(tasks: [Task]) {
        let identifiers = tasks.flatMap({ $0.notificationsIdentifiers })
        
        deschedule(identifiers: identifiers)
    }
    
    func removeFor(task: Task) {
        removeFor(tasks: [task])
    }
    
    private func notificationsFor(task: Task) -> [Notification] {
        var notifications: [Notification] = []
        let notificationsSettings = NotificationSettings.instance
        
        guard let course = task.course, // unwrap course
              task.status == .ongoing, // only for ongoing tasks
              notificationsSettings.notificationsEnabled, // if notification enabled by the user
              notificationsSettings.notificationsGranted, // if notification access granted by the user
              notificationsSettings.preferredTypes.contains(task.type), // if the preferred types include the task type
              notificationsSettings.preferredPriorities.contains(task.priority) // if the preferred priorties include the task priority
        else { return notifications }
        
        let triggerDate = DateUtilities.determineTriggerDate(target: task.dueDate, beforeDays: notificationsSettings.triggerBefore, timeConstraint: notificationsSettings.preferredTimeRange)
        
        let notification = Notification(triggerDate: triggerDate)
        notification.content.title = "\(task.name) \(task.type.rawValue)"
        notification.content.body = "\(course.name) task is due \(DateUtilities.relativeDateTimeFormatter.localizedString(for: task.dueDate, relativeTo: triggerDate))"
        notification.content.badge = 1
        notification.content.sound = (task.priority == .high) ? .defaultCritical : .default
        notification.content.categoryIdentifier = "Task"
        notification.content.userInfo["taskId"] = task.id.uuidString
        
        notifications.append(notification)
        
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
