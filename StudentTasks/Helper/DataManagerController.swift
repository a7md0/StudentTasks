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
    
    func loadData() {
        let courses = loadCourses() ?? loadSampleCourses() // Load saved courses, if not then load sample courses
        Course.injectCourses(courses: courses)

        // TODO: Trigger subject notify for courses change
        print(courses.count)
    }
    
    func saveData() {
        Course.saveData()
    }
    
    // TODO: Load and parse courses along with tasks
    private func loadCourses() -> [Course]? {
        guard let codedCourses = try? Data(contentsOf: self.archiveURL) else { return nil }
         
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Course>.self, from: codedCourses)
    }
     
    func saveCourses(courses: [Course]) {
        print("saveCourses > saving \(courses.count) courses to disk")

        let propertyEnconder = PropertyListEncoder()
        let codedCourses = try? propertyEnconder.encode(courses)
        try? codedCourses?.write(to: self.archiveURL, options: .noFileProtection)
    }
     
    private func loadSampleCourses() -> [Course] {
        let decoder = JSONDecoder()
        
        print("loading sample courses...")
        
        guard let url = Bundle.main.url(forResource: "courses_samples", withExtension: "json"),
              let coursesData = try? Data(contentsOf: url),
              let courses = try? decoder.decode(Array<Course>.self, from: coursesData) else { return [] }
        
        print("loaded sample courses")
        
        return courses
    }
    
    // TODO: Implement observer pattern for other controllers to subscribe
}
