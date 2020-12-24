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
    
    enum OrderBy: String {
        case ascending = "Ascending", descending = "Descending"
    }
    
    enum Priorty: String {
        case highest = "Highest", lowest = "lowest"
    }
}

class TasksFilter {
    var taskTypes: [TaskType] = TaskType.allCases
    var courses: [Course] = Course.findAll()
    var completeness: [TaskStatus] = TaskStatus.allCases
    
    var defaultTaskTypes: [TaskType] {
        return TaskType.allCases
    }
    
    var defaultCourses: [Course] {
        return Course.findAll()
    }
    
    var defaultCompleteness: [TaskStatus] {
        return TaskStatus.allCases
    }
    
    func restoreDefault() {
        taskTypes = defaultTaskTypes
        courses = defaultCourses
        completeness = defaultCompleteness
    }
}
