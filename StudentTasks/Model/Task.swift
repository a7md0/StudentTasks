//
//  Task.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/15/20.
//

import Foundation

// MARK: - Task model
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
    
    var grade: TaskGrade = TaskGrade()
    
    var notificationsIdentifiers: [UUID] = []
    
    var createdAt: Date?
    var updatedAt: Date?
}

// MARK: - Enums
enum TaskStatus: Int, Codable, CaseIterable, CustomStringConvertible, Equatable, Comparable {
    case ongoing = 1, completed = 2, overdue = 3
    
    var description: String {
        switch self {
        case .ongoing:
            return "Ongoing"
        case .completed:
            return "Completed"
        case .overdue:
            return "Overdue"
        }
    }

    static func == (lhs: TaskStatus, rhs: TaskStatus) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static func < (lhs: TaskStatus, rhs: TaskStatus) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum TaskType: String, Codable, CaseIterable, CustomStringConvertible {
    case assignment = "Assignment", assessment = "Assessment", project = "Project", exam = "Exam", homework = "Homework"
    
    var description: String {
        switch self {
        case .assignment:
            return "Assignment"
        case .assessment:
            return "Assessment"
        case .project:
            return "Project"
        case .exam:
            return "Exam"
        case .homework:
            return "Homework"
        }
    }
}

enum TaskPriority: Int, Codable, CaseIterable, CustomStringConvertible, Equatable, Comparable {
    case low = 2, normal = 3, high = 4
    
    var description: String {
        switch self {
        case .low:
            return "Low"
        case .normal:
            return "Normal"
        case .high:
            return "High"
        }
    }

    static func == (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Computed properties
extension Task {
    var status: TaskStatus {
        if completed {
            return .completed
        }
        
        if Date() > dueDate {
            return .overdue
        }
        
        return .ongoing
    }
    
    var brief: String {
        switch self.status {
        case .overdue:
            let relativeString = Task.relativeDateTimeFormatter.localizedString(for: self.dueDate, relativeTo: Date())
            return "Overdue by \(relativeString)"
        case .ongoing:
            let relativeString = Task.relativeDateTimeFormatter.localizedString(for: self.dueDate, relativeTo: Date())
            return "Due \(relativeString)"
        case .completed:
            let relativeString = Task.relativeDateTimeFormatter.localizedString(for: self.completedOn!, relativeTo: Date())
            return "Completed \(relativeString.replacingOccurrences(of: "in ", with: "from "))"
        }
    }
    
    var course: Course? {
        get {
            guard let courseId = self.courseId else { return nil }
            
            return Course.findOne(id: courseId)
        }
        
        set {
            courseId = newValue?.id
        }
    }
    
    private static let relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter
    }()
}

// MARK: - Mutating
extension Task {
    mutating func complete(completedOn: Date?) {
        self.completed = true
        self.completedOn = completedOn ?? Date()
        
        LocalNotificationManager.sharedInstance.removeFor(task: self)
        self.notificationsIdentifiers = []
        
        save()
    }
    
    mutating func assignTo(course: Course) {
        self.courseId = course.id
    }
}

// MARK: - CRUD operations
extension Task {
    /// This function create the current task.
    ///
    /// ```
    /// task.create()
    /// ```
    ///
    /// - Warning: This should be only called one for newely created task.
    mutating func create() {
        self.createdAt = Date()
        self.updatedAt = Date()
        
        self.notificationsIdentifiers = LocalNotificationManager.sharedInstance.prepareFor(task: self)
        
        Course.createTask(task: self)
    }
    
    /// This function save the current task.
    ///
    /// ```
    /// task.save()
    /// ```
    ///
    /// - Warning: This should be only called after updating exisiting model, not a new one.
    mutating func save() {
        self.updatedAt = Date()
        LocalNotificationManager.sharedInstance.removeFor(task: self)
        self.notificationsIdentifiers = LocalNotificationManager.sharedInstance.prepareFor(task: self)
        
        Course.saveTask(task: self)
    }
    
    /// This function remove the current task.
    ///
    /// ```
    /// task.remove()
    /// ```
    ///
    /// - Warning: This will not remove the instance itself, any local instance should be removed manually.
    mutating func remove() {
        LocalNotificationManager.sharedInstance.removeFor(task: self)
        self.notificationsIdentifiers = []
        
        Course.removeTask(task: self)
    }
}

// MARK: - Data
extension Task {
    private static var tasks: [Task] {
        return Course.findAll().map { $0.tasks }.reduce([], +) // Map all courses tasks then flatten the arrays into one
    }
    
    static func findOne(id: String?) -> Task? {
        guard let uuid = UUID(uuidString: id ?? "") else { return nil }
        
        return findOne(id: uuid)
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
