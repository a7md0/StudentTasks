//
//  Constants.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/26/20.
//

import Foundation

struct Constants {
    static let placeHolderDate = Date(timeIntervalSinceReferenceDate: -39139200) // Oct 6, 1999, 00:00 AM
    static let coursesNotifcations: [String : NSNotification.Name] = [
        "created": NSNotification.Name(rawValue: "CourseCreated"),
        "updated": NSNotification.Name(rawValue: "CourseUpdated"),
        "removed": NSNotification.Name(rawValue: "CourseRemoved"),
    ]
}
