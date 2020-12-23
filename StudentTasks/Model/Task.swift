//
//  Task.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/15/20.
//

import Foundation

struct Task: Codable, Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID() // Set universally unique identifier
    
    var name: String
    var description: String
        
    var type: TaskType
    var priority: TaskPriority
    
    var dueDate: Date

    var courseId: UUID?
    
    var completed: Bool = false
    var completedOn: Date?
    
    var graded: Bool = false
    var gradeContribution: Float?
    var gradeType: TaskGradeType?
    var grade: Float?
}

extension Task {
    var status: TaskStatus {
        return .ongoing // TOOD: Implement the logic
    }
    
    var course: Course? {
        get {
            return Course.findOne(id: id)
        }
        
        set {
            courseId = newValue?.id
        }
    }
}

extension Task {
    mutating func complete(completedOn: Date?) {
        self.completed = true
        self.completedOn = completedOn ?? Date()
        
        save()
    }
    
    mutating func assignTo(course: Course) {
        self.courseId = course.id
    }
}

extension Task {
    func create() {
        Course.createTask(task: self)
    }
    
    func save() {
        Course.saveTask(task: self)
    }
    
    func remove() {
        Course.removeTask(task: self)
    }
}

extension Task {
    private static var tasks: [Task] {
        return Course.findAll().map { $0.tasks }.reduce([], +)
    }
    
    static func findOne(id: UUID) -> Task? {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            return tasks[index]
        }
        
        return nil
    }
    
    static func findAll() -> [Task] {
       return tasks
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
