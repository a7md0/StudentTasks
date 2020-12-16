//
//  DataManagerController.swift
//  StudentCourses
//
//  Created by Ahmed Naser on 12/16/20.
//

import Foundation

class DataManagerController {
    static let sharedInstance = DataManagerController() // Static unimmutable variable which has instance of this class
    
    private let archiveURL: URL
    private var courses: [Course]
    
    private init() { // Private constructor (this class cannot be initlized from the outside)
        let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        self.archiveURL = DocumentsDirectory.appendingPathComponent("tasks").appendingPathExtension("plist")
        self.courses = []
        
        // ^ Initlize all attrs above this line
        
        // Load data
        let courses = loadCourses() ?? loadSampleCourses() // Load saved courses, if not then load sample courses
        self.courses.append(contentsOf: courses) // Add courses to the line
        // TODO: Trigger subject notify for courses change
    }
    
    // TODO: Load and parse courses along with tasks
    private func loadCourses() -> [Course]? {
        guard let codedCourses = try? Data(contentsOf: self.archiveURL) else { return nil }
         
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Course>.self, from: codedCourses)
    }
     
    private func saveCourses(_ todos: [Course]) {
        let propertyEnconder = PropertyListEncoder()
        let codedCourses = try? propertyEnconder.encode(todos)
        try? codedCourses?.write(to: self.archiveURL, options: .noFileProtection)
    }
     
    private func loadSampleCourses() -> [Course] {
        return [
            Course(name: "Mobile Programming", code: "IT8108", abberivation: "MP", tags: ["Online", "Lab"]).addTasks(tasks: [
                Task(name: "Task 1", description: "desc", type: .assignment, priority: .normal, dueDate: Date().addingTimeInterval(60*60*24*2)),
                Task(name: "Task 2", description: "desc", type: .assignment, priority: .low, dueDate: Date().addingTimeInterval(60*60*24*3)),
                Task(name: "Task 3", description: "desc", type: .assignment, priority: .high, dueDate: Date().addingTimeInterval(60*60*24*4))
            ]),
            Course(name: "Object-Oriented design", code: "IT7006", abberivation: "OD", tags: ["Online", "Lab"]).addTasks(tasks: [
                Task(name: "Task 10", description: "desc 2", type: .assignment, priority: .normal, dueDate: Date().addingTimeInterval(60*60*24*2)),
                Task(name: "Task 20", description: "desc 2", type: .assignment, priority: .low, dueDate: Date().addingTimeInterval(60*60*24*3)),
                Task(name: "Task 30", description: "desc 2", type: .assignment, priority: .high, dueDate: Date().addingTimeInterval(60*60*24*4))
            ]),
            Course(name: "Web Development", code: "IT7405", abberivation: "WD", tags: ["Online", "Lab"]).addTasks(tasks: [
                Task(name: "Task 11", description: "desc 3", type: .assignment, priority: .normal, dueDate: Date().addingTimeInterval(60*60*24*2)),
                Task(name: "Task 21", description: "desc 3", type: .assignment, priority: .low, dueDate: Date().addingTimeInterval(60*60*24*3)),
                Task(name: "Task 31", description: "desc 3", type: .assignment, priority: .high, dueDate: Date().addingTimeInterval(60*60*24*4))
            ])
        ]
    }
    
    // TODO: Keep and save data through this class
    func getCourses() -> [Course] {
        return self.courses
    }
    
    func getCoursesNames() -> [String] {
        return self.getCourses().map { $0.name }
    }
    
    func getAllTasks() -> [Task] {
        return self.getCourses().map { $0.tasks }.reduce([], +)
    }
    
    // TODO: Implement observer pattern for other controllers to subscribe
}
