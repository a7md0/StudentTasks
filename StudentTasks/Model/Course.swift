//
//  Course.swift
//  StudentTasks
//
//  Created by mobileProg on 12/15/20.
//

import Foundation

struct Course: Codable, Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id.uuidString == rhs.id.uuidString
    }
    
    var id: UUID = UUID()
    
    var name: String
    var code: String
    var abberivation: String
    
    var tags: [String]
    
    var lecturerName: String?
    var overallGrade: Grade?
    
    var ongoingTasks: Int = 0
    var completedTasks: Int = 0
    var overdueTasks: Int = 0
    
    var tasks: [Task] = []
    
    func addTask(task: Task) {
        tasks.append(task)
    }
}

struct Grade: Codable {
    
}
