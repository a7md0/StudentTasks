//
//  Task.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/15/20.
//

import Foundation

class Task: Codable, Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id.uuidString == rhs.id.uuidString
    }
    
    var id: UUID
    
    var name: String
    var description: String
        
    var status: TaskStatus {
        return .ongoing // TOOD: Implement the logic
    }
    var type: TaskType
    var priority: TaskPriority
    
    var dueDate: Date

    var course: Course?
    
    var completed: Bool
    var completedOn: Date?
    
    var graded: Bool
    var gradeContribution: Float?
    var gradeType: TaskGradeType?
    var grade: Float?
    
    convenience init(name: String, description: String, type: TaskType, priority: TaskPriority, dueDate: Date) {
        self.init(name: name, description: description, type: type, priority: priority, dueDate: dueDate, course: nil, completed: nil, completedOn: nil, graded: nil, gradeContribution: nil, gradeType: nil, grade: nil)
    }
    
    init(name: String, description: String, type: TaskType, priority: TaskPriority, dueDate: Date, course: Course?, completed: Bool?, completedOn: Date?, graded: Bool?, gradeContribution: Float?, gradeType: TaskGradeType?, grade: Float?) {
        
        self.id = UUID() // Set universally unique identifier
        
        self.name = name
        self.description = description
        
        self.type = type
        self.priority = priority
        self.dueDate = dueDate
        
        self.course = course ?? nil
        
        self.completed = completed ?? false
        self.completedOn = completedOn ?? nil
        
        self.graded = graded ?? false
        self.gradeContribution = gradeContribution ?? nil
        self.gradeType = gradeType ?? nil
        self.grade = grade ?? nil
    }
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
