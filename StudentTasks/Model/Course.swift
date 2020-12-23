//
//  Course.swift
//  StudentTasks
//
//  Created by mobileProg on 12/15/20.
//

import Foundation

struct Course: Codable, Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID() // Set universally unique identifier
    
    var imageData: Data?
    
    var name: String
    var code: String?
    var abberivation: String?
    
    var tags: [String] = []
    
    var lecturerName: String?
    var overallGrade: Grade?
    
    var ongoingTasks: Int = 0
    var completedTasks: Int = 0
    var overdueTasks: Int = 0
    
    var tasks: [Task] = []
}

extension Course {
    static func createTask(task: Task) {
        guard let course = task.course else { return }
        
        createTasks(course: course, tasks: [task])
    }
    
    static func createTask(course: Course, task: Task) {
        createTasks(course: course, tasks: [task])
    }
    
    static func createTasks(course: Course, tasks: [Task]) {
        guard let courseIndex = findCourseIndex(course: course) else { return }
        
        courses[courseIndex].tasks.append(contentsOf: tasks)
    }
    
    static func saveTask(task: Task) {
        guard let courseIndex = findCourseIndex(task: task),
              let taskIndex = findTaskIndex(course: courses[courseIndex], task: task) else { return }
        
        courses[courseIndex].tasks[taskIndex] = task
    }
    
    static func removeTask(task: Task) {
        guard let courseIndex = findCourseIndex(task: task),
              let taskIndex = findTaskIndex(course: courses[courseIndex], task: task) else { return }
        
        courses[courseIndex].tasks.remove(at: taskIndex)
    }
}

extension Course {
    func create() {
        Course.courses.append(self)
    }
    
    func save() {
        guard let courseIndex = Course.findCourseIndex(course: self) else { return }
        
        Course.courses[courseIndex] = self
    }
    
    func remove() {
        guard let courseIndex = Course.findCourseIndex(course: self) else { return }
        
        Course.courses.remove(at: courseIndex)
    }
}

extension Course {
    private static var courses: [Course] = [] {
        didSet {
            print("courses didSet \(courses.count)")
            Course.triggerUpdate()
        }
    }
    
    static func findOne(id: UUID) -> Course? {
        if let index = courses.firstIndex(where: { $0.id == id }) {
            return courses[index]
        }
        
        return nil
    }
    
    static func findAll() -> [Course] {
       return courses
    }
    
    private static func findCourseIndex(task: Task) -> Array<Course>.Index? {
        let courseIndex = courses.firstIndex(where: { $0.id == task.courseId })
        
        return courseIndex
    }
    
    private static func findCourseIndex(course: Course) -> Array<Course>.Index? {
        let courseIndex = courses.firstIndex(where: { $0 == course })
        
        return courseIndex
    }
    
    private static func findTaskIndex(course: Course, task: Task) -> Array<Task>.Index? {
        let taskIndex = course.tasks.firstIndex(where: { $0 == task })
        
        return taskIndex
    }
    
    private static func triggerUpdate() {
        print("triggerUpdate \(Course.courses.count)")
        
        subject.notify(value: Course.courses)
    }
    
    static func injectCourses(courses: [Course]) {
        print("injectCourses \(courses.count)")
        Course.courses.append(contentsOf: courses)
    }
    
    static func saveData() {
        DataManagerController.sharedInstance.saveCourses(courses: Course.courses)
    }
}

extension Course {
    private static let subject = Subject<[Course]>()
    
    static func observerInstance() -> Observer<[Course]> {
        let observer = Observer<[Course]>(subject: self.subject)
        
        return observer
    }
}

struct Grade: Codable {
    
}
