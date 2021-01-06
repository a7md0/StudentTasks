//
//  Constants.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/26/20.
//

import Foundation

struct Constants {
    static let placeHolderDate = Date(timeIntervalSinceReferenceDate: -39139200) // Oct 6, 1999, 00:00 AM
    
    static var notifcationFromTime: Date = {
        let calendar = Calendar.current
        
        let startOfTime = calendar.startOfDay(for: Date()) // GET 12:00AM of that time
        
        return startOfTime.addingTimeInterval(60 * 60 * 6)
    }()
    
    static var notifcationToTime: Date = {
        let calendar = Calendar.current
        
        let startOfTime = calendar.startOfDay(for: Date()) // GET 12:00AM of that time
        
        return startOfTime.addingTimeInterval(60 * 60 * 22)
    }()
    
    static let coursesNotifcations: [String : NSNotification.Name] = [
        "created": NSNotification.Name(rawValue: "CourseCreated"),
        "updated": NSNotification.Name(rawValue: "CourseUpdated"),
        "removed": NSNotification.Name(rawValue: "CourseRemoved"),
    ]
    static let notifcationSettings: [String : NSNotification.Name] = [
        "updated": NSNotification.Name(rawValue: "NotifcationSettingsUpdated"),
        "enabledChanged": NSNotification.Name(rawValue: "NotifcationSettingsEnabledChanged"),
    ]
    static let gradingSettingsNotifcations: [String : NSNotification.Name] = [
        "updated": NSNotification.Name(rawValue: "GradingSettingsUpdated"),
    ]
    static let appearanceSettingsNotifcations: [String : NSNotification.Name] = [
        "updated": NSNotification.Name(rawValue: "AppearanceSettingsUpdated"),
    ]
    static let tasksQueryNotifcations: [String : NSNotification.Name] = [
        "updated": NSNotification.Name(rawValue: "TasksFiltersNotifcationsUpdated"),
    ]
    
    static let daysMapping: [(key: Double, value: String)] = [
        (1, NSLocalizedString("1 Day", comment: "1 Day")),
        (2, NSLocalizedString("2 Days", comment: "2 Days")),
        (3, NSLocalizedString("3 Days", comment: "3 Days")),
        (4, NSLocalizedString("4 Days", comment: "4 Days")),
        (5, NSLocalizedString("5 Days", comment: "5 Days")),
        (6, NSLocalizedString("6 Days", comment: "6 Days")),
        (7, NSLocalizedString("1 Week", comment: "1 Week")),
        (14, NSLocalizedString("2 Weeks", comment: "2 Weeks")),
        (21, NSLocalizedString("3 Weeks", comment: "3 Weeks")),
        (28, NSLocalizedString("4 Weeks", comment: "4 Weeks")),
    ]
    
    static let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    static let developersEmails: [String] = ["201700099@student.polytechnic.bh", "201701590@student.polytechnic.bh", "201600602@student.polytechnic.bh"]
}
