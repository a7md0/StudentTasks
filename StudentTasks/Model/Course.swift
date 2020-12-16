//
//  Course.swift
//  StudentTasks
//
//  Created by mobileProg on 12/15/20.
//

import Foundation

struct Course: Codable {
    var id: Int
    
    var name: String
    var code: String
    var abberivation: String
    
    var tags: [String]
    
    var lecturerName: String
    var overallGrade: Grade
    
    var ongoingTasks: Int
    var completedTasks: Int
    var overdueTasks: Int
    
    var tasks: [Task]
}

struct Grade: Codable {
    
}
