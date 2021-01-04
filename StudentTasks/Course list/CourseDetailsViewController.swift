//
//  CourseDetailsViewController.swift
//  StudentTasks
//
//  Created by mobileProg on 1/3/21.
//

import UIKit

class CourseDetailsViewController: UIViewController {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let course = self.course {
            gradedTasks = course.tasks.filter { (task) -> Bool in
                return task.completed && task.grade.graded
            }
        }
        
        SetupTags()
        CourseDetails()
        SetupTable()
        
        print(gradedTasks.count)
        
        
        
    }
    
    
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
    
    func CourseDetails(){
        CourseName.text = course?.name
        Code.text = course?.code
        //Tutor.text = course?.lecturerName
        courseImage.backgroundColor = course?.color?.color
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CourseDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func SetupTable(){
        tableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CourseTask = gradedTasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier") as! TasksTableViewCell
        
        // Configure the cell...
        cell.taskLabel.text = CourseTask.name
        cell.subtitle.text = CourseTask.brief
        
        if let codableColor = CourseTask.course?.color {
            cell.courseImage.backgroundColor = codableColor.color
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }
    
    
}
