//
//  Search.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/23/20.
//

import Foundation

struct TasksQuery: Codable {
    var sortBy: TasksSort
    var filterBy: TasksFilter
    
    private init() {
        sortBy = TasksSort()
        filterBy = TasksFilter()
    }
}

struct TasksSort: Codable {
    var dueDate: OrderBy = .descending
    var importance: Priorty = .highest
}

struct TasksFilter: Codable {
    var taskTypes: [TaskType] = TaskType.allCases
    var taskStatus: [TaskStatus] = TaskStatus.allCases
}

extension TasksQuery {
    func save() {
        TasksQuery.instance = self
        TasksQuery.writeToPersistentStorage(query: self)
        
        DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
            NotificationCenter.default.post(name: Constants.tasksQueryNotifcations["updated"]!, object: self)
        }
    }
}

extension TasksQuery {
    static var instance: TasksQuery = loadInstance()
    
    private static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archiveURL: URL = DocumentsDirectory.appendingPathComponent("tasks_query").appendingPathExtension("plist")
    
    private static func loadInstance() -> TasksQuery {
        if let query = readFromPersistentStorage() {
            return query
        }
        
        return TasksQuery()
    }
    
    /// This function read and parse data from persistent storage into `array of Course`.
    ///
    /// ```
    /// readFromPersistentStorage()
    /// ```
    ///
    /// - Warning: It may not return result if there is none saved.
    /// - Returns: List of courses `[Course]`.
    private static func readFromPersistentStorage() -> TasksQuery? {
        guard let codedQuery = try? Data(contentsOf: archiveURL) else { return nil }
         
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(TasksQuery.self, from: codedQuery)
    }
     
    /// This function write list of courses to presistent stroage
    ///
    /// ```
    /// writeToPersistentStorage(coursesList)
    /// ```
    ///
    /// - Warning: This would overwrite any previosuly saved list.
    /// - Parameter courses: The courses list to write
    private static func writeToPersistentStorage(query: TasksQuery) {
        let propertyEnconder = PropertyListEncoder()
        let codedQuery = try? propertyEnconder.encode(query)
        try? codedQuery?.write(to: archiveURL, options: .noFileProtection)
    }
}

extension TasksSort {
    var defaultDueDate: OrderBy {
        return .descending
    }
    
    var defaultImportance: Priorty {
        return .highest
    }
    
    mutating func restoreDefault() {
        dueDate = defaultDueDate
        importance = defaultImportance
    }
}

extension TasksFilter {
    var defaultTaskTypes: [TaskType] {
        return TaskType.allCases
    }
    
    var defaultTaskStatus: [TaskStatus] {
        return TaskStatus.allCases
    }
    
    mutating func restoreDefault() {
        taskTypes = defaultTaskTypes
        taskStatus = defaultTaskStatus
    }
}

enum OrderBy: String, Codable, CaseIterable, CustomStringConvertible {
    case ascending = "Ascending", descending = "Descending"
    
    var description: String {
        switch self {
        case .ascending:
            return NSLocalizedString("Ascending", comment: "Ascending")
        case .descending:
            return NSLocalizedString("Descending", comment: "Descending")
        }
    }
}

enum Priorty: String, Codable, CaseIterable, CustomStringConvertible {
    case highest = "Highest", lowest = "Lowest"
    
    var description: String {
        switch self {
        case .highest:
            return NSLocalizedString("Highest", comment: "Highest")
        case .lowest:
            return NSLocalizedString("Lowest", comment: "Lowest")
        }
    }
}
