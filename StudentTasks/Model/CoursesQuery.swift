//
//  CoursesQuery.swift
//  StudentCourses
//
//  Created by Ahmed Naser on 1/6/21.
//

import Foundation

struct CoursesQuery: Codable {
    var sortBy: CoursesSort
    
    private init() {
        sortBy = CoursesSort()
    }
}

struct CoursesSort: Codable {
    var courseName: OrderBy = .ascending
}

extension CoursesQuery {
    func save() {
        CoursesQuery.instance = self
        CoursesQuery.writeToPersistentStorage(query: self)
    }
}

extension CoursesQuery {
    static var instance: CoursesQuery = loadInstance()
    
    private static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archiveURL: URL = DocumentsDirectory.appendingPathComponent("courses_query").appendingPathExtension("plist")
    
    private static func loadInstance() -> CoursesQuery {
        if let query = readFromPersistentStorage() {
            return query
        }
        
        return CoursesQuery()
    }
    
    /// This function read and parse data from persistent storage into `array of Course`.
    ///
    /// ```
    /// readFromPersistentStorage()
    /// ```
    ///
    /// - Warning: It may not return result if there is none saved.
    /// - Returns: List of courses `[Course]`.
    private static func readFromPersistentStorage() -> CoursesQuery? {
        guard let codedQuery = try? Data(contentsOf: archiveURL) else { return nil }
         
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(CoursesQuery.self, from: codedQuery)
    }
     
    /// This function write list of courses to presistent stroage
    ///
    /// ```
    /// writeToPersistentStorage(coursesList)
    /// ```
    ///
    /// - Warning: This would overwrite any previosuly saved list.
    /// - Parameter courses: The courses list to write
    private static func writeToPersistentStorage(query: CoursesQuery) {
        let propertyEnconder = PropertyListEncoder()
        let codedQuery = try? propertyEnconder.encode(query)
        try? codedQuery?.write(to: archiveURL, options: .noFileProtection)
    }
}

extension CoursesSort {
    var defaultCourseName: OrderBy {
        return .ascending
    }
    
    mutating func restoreDefault() {
        courseName = defaultCourseName
    }
}
