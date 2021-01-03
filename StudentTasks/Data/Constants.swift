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
        return DateUtilities.timeFormatter.date(from: "8:00 AM")!
    }()
    
    static var notifcationToTime: Date = {
        return DateUtilities.timeFormatter.date(from: "10:00 PM")!
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
        (1, "1 Day"),
        (2, "2 Days"),
        (3, "3 Days"),
        (4, "4 Days"),
        (5, "5 Days"),
        (6, "6 Days"),
        (7, "1 Week"),
        (14, "2 Weeks"),
        (21, "3 Weeks"),
        (28, "4 Weeks"),
    ]
}
