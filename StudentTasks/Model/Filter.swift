//
//  Search.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/23/20.
//

import Foundation

class TasksSort {
    var dueDate: OrderBy = .descending
    var importance: Priorty = .highest
    
    var defaultDueDate: OrderBy {
        return .descending
    }
    
    var defaultImportance: Priorty {
        return .highest
        
    }
    
    func restoreDefault() {
        dueDate = defaultDueDate
        importance = defaultImportance
    }
    
    enum OrderBy: String, CaseIterable {
        case ascending = "Ascending", descending = "Descending"
    }
    
    enum Priorty: String, CaseIterable {
        case highest = "Highest", lowest = "Lowest"
    }
}

class TasksFilter {
    var taskTypes: [TaskType] = TaskType.allCases
    var taskStatus: [TaskStatus] = TaskStatus.allCases
    
    var defaultTaskTypes: [TaskType] {
        return TaskType.allCases
    }
    
    var defaultTaskStatus: [TaskStatus] {
        return TaskStatus.allCases
    }
    
    func restoreDefault() {
        taskTypes = defaultTaskTypes
        taskStatus = defaultTaskStatus
    }
}
