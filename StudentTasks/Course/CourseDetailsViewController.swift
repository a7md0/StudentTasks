//
//  CourseDetailsViewController.swift
//  StudentTasks
//
//  Created by mobileProg on 1/3/21.
//

import UIKit

class CourseDetailsViewController: UIViewController {
    // declaring variables and refrencing outlets
    @IBOutlet weak var tableView: UITableView!
        
    var course: Course?
    var gradedTasks : [Task] = []
    @IBOutlet weak var courseTag1: UILabel!
    @IBOutlet weak var courseTag2: UILabel!
    @IBOutlet weak var courseTag3: UILabel!
    @IBOutlet weak var courseTag4: UILabel!
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var Code: UILabel!
    @IBOutlet weak var Tutor: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var overallGradeLabel: UILabel!
    @IBOutlet weak var completedTasksLabel: UILabel!
    @IBOutlet weak var ongoingTasksLabel: UILabel!
    @IBOutlet weak var overdueTasksLabel: UILabel!
    @IBOutlet var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let course = self.course {
            gradedTasks = course.tasks.filter { (task) -> Bool in
                return task.completed && task.grade.graded
            }
            
            navigationItem.title = course.name
        }
        
        SetupTags()
        setupStats()
        CourseDetails()
        SetupTable()
        
        print(gradedTasks.count)
        
        
        
    }
    // setup the horizontal stats
    func setupStats() {
        guard let course = self.course else { return }
        
        self.overallGradeLabel.text = course.overallFormattedGrade
        self.completedTasksLabel.text = "\(course.completedTasks)"
        self.ongoingTasksLabel.text = "\(course.ongoingTasks)"
        self.overdueTasksLabel.text = "\(course.overdueTasks)"
    }
    // setup tags shape and radius and checking how many tags that the course have and show then acordangly
    func SetupTags(){
        courseTag1.layer.cornerRadius = 15
        courseTag2.layer.cornerRadius = 15
        courseTag3.layer.cornerRadius = 15
        courseTag4.layer.cornerRadius = 15
        courseImage.layer.cornerRadius = courseImage.frame.size.width/2
        courseImage.clipsToBounds = true
        if(course?.tags.count == 1) {
            courseTag2.isHidden = true
            courseTag3.isHidden = true
            courseTag4.isHidden = true
            courseTag1.text = course?.tags[0].rawValue
        } else if(course?.tags.count == 2) {
            courseTag3.isHidden = true
            courseTag4.isHidden = true
            courseTag1.text = course?.tags[0].rawValue
            courseTag2.text = course?.tags[1].rawValue
        } else if(course?.tags.count == 3) {
            
            courseTag4.isHidden = true
            courseTag1.text = course?.tags[0].rawValue
            courseTag2.text = course?.tags[1].rawValue
            courseTag3.text = course?.tags[2].rawValue
        } else if (course?.tags.count == 4) {
            courseTag1.text = course?.tags[0].rawValue
            courseTag2.text = course?.tags[1].rawValue
            courseTag3.text = course?.tags[2].rawValue
            courseTag4.text = course?.tags[3].rawValue
        }
    }
    // Adding the course details to the text fields
    func CourseDetails(){
        CourseName.text = course?.name
        Code.text = course?.code
        //Tutor.text = course?.lecturerName
        courseImage.backgroundColor = course?.color?.color
        
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "editCourseSegue",
           let courseForm = segue.destination as? CourseFormTableViewController {
            
            courseForm.course = self.course
            courseForm.unwindSegue = "unwindToCourseDetailsFromEdit"
        }
     }
    
    @IBAction func unwindToCourseDetails(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if let courseForm = sourceViewController as? CourseFormTableViewController {
            self.course = courseForm.course
            
            setupStats()
            CourseDetails()
            
            if let course = self.course {
                gradedTasks = course.tasks.filter { (task) -> Bool in
                    return task.completed && task.grade.graded
                }
            }
            tableView.reloadData()
        }
    }
}

extension CourseDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    // Setup table footer
    func SetupTable(){
        tableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
    }
    // Checking number of graded tasks
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = gradedTasks.count
        
        tableView.backgroundView = count == 0 ? self.noDataView : nil
        
        return count
    }
    // configuring the Cell attributes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier") as! CompletedTaskTableViewCell
        
        // Configure the cell...
        let task = gradedTasks[indexPath.row]
        
        cell.title.text = task.name
        cell.subtitle.text = task.brief
        cell.rightDetails.text = task.grade.formattedGrade
        
        
        
        return cell
        
    }
    // Deslecting row after clicking on it
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //Changing task Row Hight
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }
    
    
}
