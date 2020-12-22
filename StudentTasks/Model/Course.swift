//
//  Course.swift
//  StudentTasks
//
//  Created by mobileProg on 12/15/20.
//

import Foundation

class Course: Codable, Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
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
}

extension Course {
    func attachTask(task: Task) -> Course {
        return self.attachTasks(tasks: [task])
    }
    
    func attachTasks(tasks: [Task]) -> Course {
        tasks.forEach { $0.course = self } // Set each task course ref
        self.tasks.append(contentsOf: tasks)
        
        return self
    }
    
    func taskSaved(task: Task) {
        save()
    }
    
    func taskRemoved(task: Task) {
        guard let index = self.tasks.firstIndex(where: { $0 == task }) else { return }
        
        tasks.remove(at: index)
        save()
    }
}

extension Course {
    func create() {
        Course.courses.append(self)
        triggerSave()
    }
    
    func save() {
        triggerSave()
    }
    
    func remove() {
        if let index = Course.courses.firstIndex(where: { $0 == self }) {
            Course.courses.remove(at: index)
            triggerSave()
        }
    }
    
    private func triggerSave() {
        print("triggerSave \(Course.courses.count)")
        DataManagerController.sharedInstance.saveCourses(courses: Course.courses)
    }
}

extension Course {
    private static var courses: [Course] = []
    
    static func findOne(id: UUID) -> Course? {
        if let index = courses.firstIndex(where: { $0.id == id }) {
            return courses[index]
        }
        
        return nil
    }
    
    static func findAll() -> [Course] {
       return courses
    }
    
    static func injectCourses(courses: [Course]) {
        print("injectCourses \(courses.count)")
        self.courses.append(contentsOf: courses)
    }
}

struct Grade: Codable {
    
}
