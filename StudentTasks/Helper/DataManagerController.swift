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
    
    private init() { // Private constructor (this class cannot be initlized from the outside)
        let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        self.archiveURL = DocumentsDirectory.appendingPathComponent("tasks").appendingPathExtension("plist")
        
        // ^ Initlize all attrs above this line
        
        // Load data
        //loadInitalData()
    }
    
    func loadInitalData() {
        let courses = loadSampleCourses() // Load saved courses, if not then load sample courses
        Course.injectCourses(courses: courses)
        
        let tasks = courses.map { $0.tasks }.reduce([], +)
        Task.injectTasks(tasks: tasks)

        // TODO: Trigger subject notify for courses change
        print(courses)
    }
    
    // TODO: Load and parse courses along with tasks
    private func loadCourses() -> [Course]? {
        guard let codedCourses = try? Data(contentsOf: self.archiveURL) else { return nil }
         
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Course>.self, from: codedCourses)
    }
     
    func saveCourses(courses: [Course]) {
        print("saveCourses \(courses.count)")

        let propertyEnconder = PropertyListEncoder()
        let codedCourses = try? propertyEnconder.encode(courses)
        try? codedCourses?.write(to: self.archiveURL, options: .noFileProtection)
    }
     
    private func loadSampleCourses() -> [Course] {
        return [
            Course(name: "Mobile Programming", code: "IT8108", abberivation: "MP", tags: ["Online", "Lab"]).attachTasks(tasks: [
                Task(name: "Task 1", description: "desc", type: .assignment, priority: .normal, dueDate: Date().addingTimeInterval(60*60*24*2)),
                Task(name: "Task 2", description: "desc", type: .assignment, priority: .low, dueDate: Date().addingTimeInterval(60*60*24*3)),
                Task(name: "Task 3", description: "desc", type: .assignment, priority: .high, dueDate: Date().addingTimeInterval(60*60*24*4))
            ]),
            Course(name: "Object-Oriented design", code: "IT7006", abberivation: "OD", tags: ["Online", "Lab"]).attachTasks(tasks: [
                Task(name: "Task 10", description: "desc 2", type: .assignment, priority: .normal, dueDate: Date().addingTimeInterval(60*60*24*2)),
                Task(name: "Task 20", description: "desc 2", type: .assignment, priority: .low, dueDate: Date().addingTimeInterval(60*60*24*3)),
                Task(name: "Task 30", description: "desc 2", type: .assignment, priority: .high, dueDate: Date().addingTimeInterval(60*60*24*4))
            ]),
            Course(name: "Web Development", code: "IT7405", abberivation: "WD", tags: ["Online", "Lab"]).attachTasks(tasks: [
                Task(name: "Task 11", description: "desc 3", type: .assignment, priority: .normal, dueDate: Date().addingTimeInterval(60*60*24*2)),
                Task(name: "Task 21", description: "desc 3", type: .assignment, priority: .low, dueDate: Date().addingTimeInterval(60*60*24*3)),
                Task(name: "Task 31", description: "desc 3", type: .assignment, priority: .high, dueDate: Date().addingTimeInterval(60*60*24*4))
            ])
        ]
    }
    
    // TODO: Implement observer pattern for other controllers to subscribe
}
