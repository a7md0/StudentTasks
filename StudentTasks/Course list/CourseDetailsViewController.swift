//
//  CourseDetailsViewController.swift
//  StudentTasks
//
//  Created by mobileProg on 1/3/21.
//

import UIKit

class CourseDetailsViewController: UIViewController {
    var Course1 = Course.findAll()
    @IBOutlet weak var CourseTasktbl: UITableView!
    
    var chosingcourse: Course!
    var Tasks : [Task] = []
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
        
        CourseTasktbl.delegate = self
        CourseTasktbl.dataSource = self
        chosingcourse = Course1[1]
        Tasks = chosingcourse.tasks.filter { (task) -> Bool in
                        return task.completed && task.grade.graded
                    }
        SetupTags()
        CourseDetails()
        print(Tasks.count)

        

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CourseTask = Tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier") as! TasksTableViewCell

        // Configure the cell...
        cell.taskLabel.text = CourseTask.name
        cell.subtitle.text = CourseTask.brief

        if let codableColor = CourseTask.course?.color {
            cell.courseImage.backgroundColor = codableColor.color
        }
        tableView.reloadData()
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }
    func SetupTable(){
        CourseTasktbl.delegate = self
        CourseTasktbl.dataSource = self
    }
    func SetupTags(){
        courseTag1.layer.cornerRadius = 15
        courseTag2.layer.cornerRadius = 15
        courseTag3.layer.cornerRadius = 15
        courseTag4.layer.cornerRadius = 15
        courseImage.layer.cornerRadius = courseImage.frame.size.width/2
        courseImage.clipsToBounds = true
        if(chosingcourse?.tags.count == 1)
        {
            courseTag2.isHidden = true
            courseTag3.isHidden = true
            courseTag4.isHidden = true
            courseTag1.text = chosingcourse?.tags[0].rawValue
            
        }
        else if(chosingcourse?.tags.count == 2)
        {
            courseTag3.isHidden = true
            courseTag4.isHidden = true
            courseTag1.text = chosingcourse?.tags[0].rawValue
            courseTag2.text = chosingcourse?.tags[1].rawValue
        }
        else if(chosingcourse?.tags.count == 3)
        {
            
            courseTag4.isHidden = true
            courseTag1.text = chosingcourse?.tags[0].rawValue
            courseTag2.text = chosingcourse?.tags[1].rawValue
            courseTag3.text = chosingcourse?.tags[2].rawValue
        }
        else if(chosingcourse?.tags.count == 4)
        {
            courseTag1.text = chosingcourse?.tags[0].rawValue
            courseTag2.text = chosingcourse?.tags[1].rawValue
            courseTag3.text = chosingcourse?.tags[2].rawValue
            courseTag4.text = chosingcourse?.tags[3].rawValue
        }
        
    }
    func CourseDetails(){
        CourseName.text = chosingcourse?.name
        Code.text = chosingcourse?.code
        //Tutor.text = chosingcourse?.lecturerName
        courseImage.backgroundColor = chosingcourse?.color?.color
        
    }
}
