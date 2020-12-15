//
//  Task.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/15/20.
//

import Foundation

class Task: Codable {
    var id: Int
    
    var name: String
    var description: String
    
    var course: Course
    
    var status: TaskStatus
    var type: TaskType
    var priority: TaskPriority
    
    var dueDate: Date?
    
    var completed: Bool
    var completedOn: Date?
    
    var graded: Bool
    var gradeContribution: Float?
    var gradeType: TaskGradeType?
    var grade: Float?
}

enum TaskStatus: String, Codable {
    case upcoming, completed, overdue
}

enum TaskType: String, Codable {
    case assignment, assessment, project, exam, homework
}

enum TaskPriority: String, Codable {
    case low, normal, high
}

enum TaskGradeType: String, Codable {
    case courseTotal, mainTask
}
