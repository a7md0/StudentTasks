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
    case completed = 1, ongoing = 2, overdue = 3
    
    var description: String {
        switch self {
        case .completed:
            return NSLocalizedString("Completed", comment: "Completed")
        case .ongoing:
            return NSLocalizedString("Ongoing", comment: "Ongoing task")
        case .overdue:
            return NSLocalizedString("Overdue", comment: "Overdue")
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
            return NSLocalizedString("Assignment", comment: "Assignment")
        case .assessment:
            return NSLocalizedString("Assessment", comment: "Assessment")
        case .project:
            return NSLocalizedString("Project", comment: "Project")
        case .exam:
            return NSLocalizedString("Exam", comment: "Exam")
        case .homework:
            return NSLocalizedString("Homework", comment: "Homework")
        }
    }
}

enum TaskPriority: Int, Codable, CaseIterable, CustomStringConvertible, Equatable, Comparable {
    case low = 2, normal = 3, high = 4
    
    var description: String {
        switch self {
        case .low:
            return NSLocalizedString("Low", comment: "Low")
        case .normal:
            return NSLocalizedString("Normal", comment: "Normal")
        case .high:
            return NSLocalizedString("High", comment: "High")
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
            let formatString = NSLocalizedString("Overdue.by.s",
                                                 comment: "Overdue by 1 day")
            
            return String.localizedStringWithFormat(formatString, relativeString)
        case .ongoing:
            let relativeString = Task.relativeDateTimeFormatter.localizedString(for: self.dueDate, relativeTo: Date())
            let formatString = NSLocalizedString("due.s",
                                                 comment: "Due in 1 day")
            
            return String.localizedStringWithFormat(formatString, relativeString)
        case .completed:
            let relativeString = Task.relativeDateTimeFormatter.localizedString(for: self.completedOn!, relativeTo: Date())
            let formatString = NSLocalizedString("Completed.s",
                                                 comment: "Overdue by 1 day")
            
            return String.localizedStringWithFormat(formatString, relativeString)
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
    
    var formattedGrade: String {
        var formatted: String?
        
        if let grade = self.grade.grade {
            let gradingSettings = GradingSettings.instance
            
            switch gradingSettings.gpaModel {
            case .fourPlus:
                formatted = GradeUtilities.forPlusMapper(grade: grade)
            case .fourPlusMinus:
                formatted = GradeUtilities.forPlusMinusMapper(grade: grade)
            case .hundredPercentage:
                formatted = GradeUtilities.percentageFormatter.string(for: grade)
            }
        }
        
        return formatted ?? "-"
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
        return Course.findAll().flatMap { $0.tasks } // Map all courses tasks then flatten the arrays into one
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
