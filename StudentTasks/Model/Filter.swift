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
    
    enum OrderBy: String {
        case ascending = "Ascending", descending = "Descending"
    }
    
    enum Priorty: String {
        case highest = "Highest", lowest = "lowest"
    }
    
    func restoreDefault() {
        dueDate = .descending
        importance = .highest
    }
    
    func isDefault() -> Bool {
        if dueDate == .descending && importance == .highest {
            return true
        }
        
        return false
    }
}

class TasksFilter {
    var taskTypes: [TaskType] = TaskType.allCases
    var courses: [Course] = Course.findAll()
    var completeness: [TaskStatus] = TaskStatus.allCases
    
    func restoreDefault() {
        taskTypes = TaskType.allCases
        courses = Course.findAll()
        completeness = TaskStatus.allCases
    }
    
    func isDefault() -> Bool {
        if taskTypes == TaskType.allCases && completeness == TaskStatus.allCases {
            return true
        }
        
        return false
    }
}
