//
//  Constants.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/26/20.
//

import Foundation

struct Constants {
    static let placeHolderDate = Date(timeIntervalSinceReferenceDate: -39139200) // Oct 6, 1999, 00:00 AM
    
    static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        return formatter
    }()
    
    static var notifcationFromTime: Date = {
        return Constants.timeFormatter.date(from: "8:00 AM")!
    }()
    
    static var notifcationToTime: Date = {
        return Constants.timeFormatter.date(from: "10:00 PM")!
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
}
