//
//  Course.swift
//  StudentTasks
//
//  Created by mobileProg on 12/15/20.
//

import Foundation

class Course: Codable, Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id.uuidString == rhs.id.uuidString
    }
    
    var id: UUID
    
    var imageData: Data?
    
    var name: String
    var code: String?
    var abberivation: String?
    
    var tags: [String]
    
    var lecturerName: String?
    var overallGrade: Grade?
    
    var ongoingTasks: Int
    var completedTasks: Int
    var overdueTasks: Int
    
    var tasks: [Task]
    
    convenience init(name: String) {
        self.init(name: name, code: nil, abberivation: nil, tags: nil, lecturerName: nil, overallGrade: nil, ongoingTasks: nil, completedTasks: nil, overdueTasks: nil, tasks: nil)
    }
    
    convenience init(name: String, code: String) {
        self.init(name: name, code: code, abberivation: nil, tags: nil, lecturerName: nil, overallGrade: nil, ongoingTasks: nil, completedTasks: nil, overdueTasks: nil, tasks: nil)
    }
    
    convenience init(name: String, code: String, abberivation: String) {
        self.init(name: name, code: code, abberivation: abberivation, tags: nil, lecturerName: nil, overallGrade: nil, ongoingTasks: nil, completedTasks: nil, overdueTasks: nil, tasks: nil)
    }
    
    convenience init(name: String, code: String, abberivation: String, tags: [String]) {
        self.init(name: name, code: code, abberivation: abberivation, tags: tags, lecturerName: nil, overallGrade: nil, ongoingTasks: nil, completedTasks: nil, overdueTasks: nil, tasks: nil)
    }
    
    init(name: String, code: String?, abberivation: String?, tags: [String]?, lecturerName: String?, overallGrade: Grade?, ongoingTasks: Int?, completedTasks: Int?, overdueTasks: Int?, tasks: [Task]?) {
        
        self.id = UUID() // Set universally unique identifier
        
        self.name = name
        self.code = code ?? nil
        self.abberivation = abberivation ?? nil
        
        self.tags = tags ?? []
        
        self.lecturerName = lecturerName ?? nil
        self.overallGrade = overallGrade ?? nil
    
        self.ongoingTasks = ongoingTasks ?? 0
        self.completedTasks = completedTasks ?? 0
        self.overdueTasks = overdueTasks ?? 0
        
        self.tasks = tasks ?? []
    }
    
    func addTask(task: Task) -> Course {
        task.course = self // Set task course ref
        tasks.append(task)
        
        return self // return the course itself ref (chaining)
    }
    
    func addTasks(tasks: [Task]) -> Course {
        tasks.forEach { $0.course = self } // Set each task course ref
        self.tasks.append(contentsOf: tasks)
        
        return self // return the course itself ref (chaining)
    }
}

struct Grade: Codable {
    
}
