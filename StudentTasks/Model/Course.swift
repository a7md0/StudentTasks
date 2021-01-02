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
    
    @available(*, deprecated, message: "use color: instead")
    var imageData: Data?
    
    var color: CodableColor?
    
    var name: String
    var code: String?
    var abberivation: String?
    
    var tags: [CourseTag] = []
    
    var lecturerName: String?
    
    var tasks: [Task] = []
    
    var createdAt: Date?
    var updatedAt: Date?
}

// MARK: - Enums
enum CourseTag: String, Codable, CaseIterable {
    case online = "Online", lab = "Lab", lecture = "Lecture"
}

// MARK: - Computed properties
extension Course {
    var overallGrade: Decimal? {
        return GradeUtilities.calculateOverallGradeFor(tasks: self.tasks)
    }
    
    var overallFormattedGrade: String {
        var formatted: String?
        
        if let overall = overallGrade {
            let gradingSettings = GradingSettings.load()
            
            switch gradingSettings.gpaModel {
            case .fourPlus:
                formatted = GradeUtilities.forPlusMapper(grade: overall)
            case .fourPlusMinus:
                formatted = GradeUtilities.forPlusMinusMapper(grade: overall)
            case .hundredPercentage:
                formatted = GradeUtilities.percentageFormatter.string(for: overall)
            }
        }
        
        return formatted ?? "-"
    }
    
    var ongoingTasks: Int {
        return self.tasks.filter { $0.status == .ongoing }.count
    }
    
    var completedTasks: Int {
        return self.tasks.filter { $0.status == .completed }.count
    }
    
    var overdueTasks: Int {
        return self.tasks.filter { $0.status == .overdue }.count
    }
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
        Course.notifyUpdated(course: courses[courseIndex])
    }
    
    static func saveTask(task: Task) {
        guard let courseIndex = findCourseIndex(task: task),
              let taskIndex = findTaskIndex(course: courses[courseIndex], task: task) else { return }
        
        courses[courseIndex].tasks[taskIndex] = task
        Course.notifyUpdated(course: courses[courseIndex])
    }
    
    static func removeTask(task: Task) {
        guard let courseIndex = findCourseIndex(task: task),
              let taskIndex = findTaskIndex(course: courses[courseIndex], task: task) else { return }
        
        courses[courseIndex].tasks.remove(at: taskIndex)
        Course.notifyUpdated(course: courses[courseIndex])
    }
}

// MARK: - CRUD operations
extension Course {
    mutating func create() {
        self.createdAt = Date()
        self.updatedAt = Date()
        
        Course.courses.append(self)
        Course.notifyCreated(course: self)
    }
    
    mutating func save() {
        guard let courseIndex = Course.findCourseIndex(course: self) else { return }
        self.updatedAt = Date()
        
        Course.courses[courseIndex] = self
        Course.notifyUpdated(course: self)
    }
    
    func remove() {
        guard let courseIndex = Course.findCourseIndex(course: self) else { return }
        
        Course.courses.remove(at: courseIndex)
        Course.notifyRemoved(course: self)
    }
}

// MARK: - Notification Center
extension Course {
    private static func notifyCreated(course: Course) {
        DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
            NotificationCenter.default.post(name: Constants.coursesNotifcations["created"]!, object: course)
        }
    }
    
    private static func notifyUpdated(course: Course) {
        DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
            NotificationCenter.default.post(name: Constants.coursesNotifcations["updated"]!, object: course)
        }
    }
    
    private static func notifyRemoved(course: Course) {
        DispatchQueue.main.async { // Avoid crashing issue where observers must me in the main thread
            NotificationCenter.default.post(name: Constants.coursesNotifcations["removed"]!, object: course)
        }
    }
}

// MARK: - Data
extension Course {
    private static var courses: [Course] = []
    
    static func findOne(id: String?) -> Course? {
        guard let uuid = UUID(uuidString: id ?? "") else { return nil }
        
        return findOne(id: uuid)
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
    private static func readSampleData() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Use ISO-8601 -> 2018-12-25T17:30:00Z
        
        print("loading sample courses...")
        
        guard let url = Bundle.main.url(forResource: "courses_samples", withExtension: "json"),
              let coursesData = try? Data(contentsOf: url),
              var courses = try? decoder.decode(Array<Course>.self, from: coursesData) else { return }

        let todayDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date()) // current date components
        
        for courseIndex in courses.indices {
            var tasks: [Task] = courses[courseIndex].tasks // Copy the course tasks temporarily

            for taskIndex in tasks.indices { // For each loop over the temporarily saved tasks
                let dueDate = tasks[taskIndex].dueDate // keep copy of due date
                let compareDate = Calendar.current.compare(Constants.placeHolderDate, to: dueDate, toGranularity: .year) // compare the due date to the saved place holder by only year (1999)
                
                if compareDate == .orderedSame { // If the date compare match
                    var dueDateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: dueDate) // Extract components from due date
                    let multipler = (dueDateComponents.month! == 6) ? -1 : (dueDateComponents.month! == 7) ? 1 : 0 // Multipler for day by month number
                    
                    dueDateComponents.year = todayDateComponents.year! // Set to current year
                    dueDateComponents.month = todayDateComponents.month! // Set to current month
                    dueDateComponents.day = todayDateComponents.day! + (dueDateComponents.day! * multipler) // Set to current date +- the due date place holder date multipled by either 0 or -1
                    
                    tasks[taskIndex].dueDate = Calendar.current.date(from: dueDateComponents)! // Set the new due date
                }
            }
            
            courses[courseIndex].tasks = [] // Deatch tasks from the course
            courses[courseIndex].create() // Create the course
            
            for taskIndex in tasks.indices { // For each loop over the temporarily saved tasks
                tasks[taskIndex].create() // Create the task
            }
        }
        
        print("created sample courses")
    }
    
    /// This function load the required data for this model
    ///
    /// ```
    /// loadData()
    /// ```
    static func loadData() {
        if let savedCourses = readFromPersistentStorage() {
            courses.append(contentsOf: savedCourses)
        } else {
            readSampleData()
        }
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
