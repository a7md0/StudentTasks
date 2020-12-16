//
//  Task.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/15/20.
//

import Foundation

struct Task: Codable, Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id.uuidString == rhs.id.uuidString
    }
    
    var id: UUID = UUID()
    
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
    case ongoing = "Ongoing", completed = "Completed", overdue = "Overdue"
}

enum TaskType: String, Codable {
    case assignment = "Assignment", assessment = "Assessment", project = "Project", exam = "Exam", homework = "Homework"
}

enum TaskPriority: String, Codable {
    case low = "Low", normal = "Normal", high = "High"
}

enum TaskGradeType: String, Codable {
    case courseTotal = "Course Total", mainTask = "Main Task"
}
