//
//  DataManagerController.swift
//  StudentCourses
//
//  Created by Ahmed Naser on 12/16/20.
//

import Foundation

class DataManagerController {
    static let sharedInstance = DataManagerController() // Static unimmutable variable which has instance of this class
    
    let archiveURL: URL = {
         let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         
         return DocumentsDirectory.appendingPathComponent("tasks").appendingPathExtension("plist")
     }()
    
    private init() { } // Private constructor (this class cannot be initlized from the outside)
    
    // TODO: Load and parse courses along with tasks
    func loadCourses() -> [Course]? {
        guard let codedCourses = try? Data(contentsOf: self.archiveURL) else { return nil }
         
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Course>.self, from: codedCourses)
    }
     
    func saveCourses(_ todos: [Course]) {
        let propertyEnconder = PropertyListEncoder()
        let codedCourses = try? propertyEnconder.encode(todos)
        try? codedCourses?.write(to: self.archiveURL, options: .noFileProtection)
    }
     
    func loadSampleCourses() -> [Course] {
        return [
            Course(name: "Mobile Programming", code: "IT8108", abberivation: "MP", tags: ["Online", "Lab"], lecturerName: "John", tasks: [
                Task(name: "Task 1", description: "desc", course: pare, status: <#T##TaskStatus#>, type: <#T##TaskType#>, priority: <#T##TaskPriority#>, completed: <#T##Bool#>, graded: <#T##Bool#>)
            ])
        ]
    }
    
    
    
    // TODO: Keep and save data through this class
    // TODO: Implement observer pattern for other controllers to subscribe
}
