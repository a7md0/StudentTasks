//
//  DateUtilities.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/1/21.
//

import Foundation

struct DateUtilities {
    static let calendar = Calendar.current
    
    static let relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter
    }()
    
    static func combineDate(_ date: Date, time: Date) -> Date {
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        let startOfDate = calendar.startOfDay(for: date)
        
        return calendar.date(byAdding: timeComponents, to: startOfDate)!
    }

    static func tommorowDate(at: Date) -> Date {
        let timeComponents = calendar.dateComponents([.hour, .minute], from: at)
        
        let dateComponents = DateComponents(calendar: calendar, day: 1, hour: timeComponents.hour, minute: timeComponents.minute)
        let tommorow = calendar.date(byAdding: dateComponents, to: Date())
            
        return tommorow!
    }

    static func determineTriggerDate(target: Date, beforeDays: Double, timeConstraint: DateInterval) -> Date {
        var suggestedTriggerOn = target.addingTimeInterval(-(3600 * 24 * beforeDays))
        
        let triggerToday = Date().advanced(by: 60) // Now +60s
        let comparedToday = Calendar.current.compare(suggestedTriggerOn, to: triggerToday, toGranularity: .day) // compare suggested by today (day without time)
        
        if comparedToday == .orderedAscending || comparedToday == .orderedSame { // is suggested <= today? (compared to day only without time)
            suggestedTriggerOn = triggerToday // suggest today to trigger
        }
        
        let inTimeRange = compareTime(suggestedTriggerOn, between: timeConstraint) // Compare the suggested date time with the allowed time
        
        if !inTimeRange { // is the suggested trigger not in the allowed time?
            suggestedTriggerOn = combineDate(suggestedTriggerOn, time: timeConstraint.start) // Combine the suggested with the allowed time start
            
            if suggestedTriggerOn < triggerToday { // is the suggested trigger datetime less than current?
                suggestedTriggerOn = tommorowDate(at: timeConstraint.start) // Get tommorow date at the allowed time
            }
        }
        
        return suggestedTriggerOn // return the determined date
    }
    
    /*
     Source: https://stackoverflow.com/a/55139115/1738413
     Author: M Murteza
     
     Updated: Ahmed Naser
     */
    static func compareTime(_ time: Date, between: DateInterval) -> Bool{
        let calendar = Calendar.current
        
        let startTimeComponents = calendar.dateComponents([.hour, .minute], from: between.start)
        let endTimeComponents = calendar.dateComponents([.hour, .minute], from: between.end)
        
        let startOfTime = calendar.startOfDay(for: time) // GET 12:00AM of that time
        let startTime = calendar.date(byAdding: startTimeComponents, to: startOfTime)!
        let endTime = calendar.date(byAdding: endTimeComponents, to: startOfTime)!
        
        return startTime <= time && time <= endTime
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
    
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        return formatter
    }()
}
