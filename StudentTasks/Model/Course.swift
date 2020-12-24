//
//  Course.swift
//  StudentTasks
//
//  Created by mobileProg on 12/15/20.
//

import Foundation

// MARK: - Course model
struct Course: Codable, Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID() // Set universally unique identifier
    
    var imageData: Data?
    
    var name: String
    var code: String?
    var abberivation: String?
    
    var tags: [CourseTag] = []
    
    var lecturerName: String?
    var overallGrade: Grade?
    
    var ongoingTasks: Int = 0
    var completedTasks: Int = 0
    var overdueTasks: Int = 0
    
    var tasks: [Task] = []
}

// MARK: - Enums
enum CourseTag: String, Codable, CaseIterable {
    case online = "Online", lab = "Lab", lecture = "Lecture"
}

// MARK: - Sub
struct Grade: Codable {
    
}

// MARK: - Tasks mutation
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

// MARK: - CRUD operations
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

// MARK: - Data
extension Course {
    private static var courses: [Course] = [] {
        didSet {
            print("courses didSet \(courses.count)")
            Course.triggerUpdate()
        }
    }
    
    static func findOne(id: String) -> Course? {
        return findOne(id: UUID(uuidString: id)!)
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
}

// MARK: - Observer pattern
extension Course {
    private static let subject = Subject<[Course]>()
    
    static func observerInstance() -> Observer<[Course]> {
        let observer = Observer<[Course]>(subject: self.subject)
        
        return observer
    }
}

// MARK: - Persistent storage
extension Course {
    private static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archiveURL: URL = DocumentsDirectory.appendingPathComponent("courses").appendingPathExtension("plist")
    
    /// This function read and parse data from persistent storage into `array of Course`.
    ///
    /// ```
    /// readFromPersistentStorage()
    /// ```
    ///
    /// - Warning: It may not return result if there is none saved.
    /// - Returns: List of courses `[Course]`.
    private static func readFromPersistentStorage() -> [Course]? {
        guard let codedCourses = try? Data(contentsOf: archiveURL) else { return nil }
         
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Course>.self, from: codedCourses)
    }
     
    /// This function write list of courses to presistent stroage
    ///
    /// ```
    /// writeToPersistentStorage(coursesList)
    /// ```
    ///
    /// - Warning: This would overwrite any previosuly saved list.
    /// - Parameter courses: The courses list to write
    private static func writeToPersistentStorage(courses: [Course]) {
        print("saveCourses > saving \(courses.count) courses to disk")

        let propertyEnconder = PropertyListEncoder()
        let codedCourses = try? propertyEnconder.encode(courses)
        try? codedCourses?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /// This function read and parse sample entries then return list of courses
    ///
    /// ```
    /// readSampleData()
    /// ```
    ///
    /// - Returns: List of sample courses `[Course]`.
    private static func readSampleData() -> [Course] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Use ISO-8601 -> 2018-12-25T17:30:00Z
        
        print("loading sample courses...")
        
        guard let url = Bundle.main.url(forResource: "courses_samples", withExtension: "json"),
              let coursesData = try? Data(contentsOf: url),
              let courses = try? decoder.decode(Array<Course>.self, from: coursesData) else { return [] }
        
        print("loaded sample courses")
        
        return courses
    }
    
    /// This function load the required data for this model
    ///
    /// ```
    /// loadData()
    /// ```
    static func loadData() {
        courses = readFromPersistentStorage() ?? readSampleData() // Load saved courses, if not then load sample courses
    }
    
    /// This function save the data for this model
    ///
    /// ```
    /// saveData()
    /// ```
    static func saveData() {
        writeToPersistentStorage(courses: Course.courses)
    }
}
