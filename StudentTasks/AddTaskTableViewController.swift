//
//  AddTaskTableViewController.swift
//  StudentTasks
//
//  Created by Sayed Ali on 12/25/20.
//

import UIKit

class AddTaskTableViewController: UITableViewController {
    var chosinCourse: Course?
    var taskType: TaskType?

    //IBOut
    
    @IBOutlet weak var taskNameField: UITextField!
    
    @IBOutlet weak var taskTypeBtn: UIButton!
    @IBOutlet weak var courseChooseBtn: UIButton!
    
    @IBOutlet weak var prtiotySegment: UISegmentedControl!
    @IBOutlet weak var dateChoose: UIDatePicker!
    
    @IBOutlet weak var gradedAsSegment: UISegmentedControl!
    @IBOutlet weak var contributionTextField: UITextField!
    @IBOutlet weak var gradingSystemBtn: UISwitch!
    @IBOutlet weak var desciptionTextField: UITextView!
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        var task = Task.init(name: taskNameField.text!, description: desciptionTextField.text, type: taskType!, priority: TaskPriority.normal, dueDate: dateChoose.date)
        task.course = chosinCourse!
        task.create()
        //print(chosinCourse)
        print(task.name)
        print(task)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func unwindtoAddtask(_ sender: UIStoryboardSegue){
        if sender.identifier == "unwindAddTask",
           let pickerTableView = sender.source as? PickerTableViewController{
          //  print (pickerTableView.items)
           
            if pickerTableView.identifier == "CourseChoose"{
            var courseid: String
            for courselist in pickerTableView.items{
                if courselist.checked == true{
                    courseid = courselist.identifier
                 //   print(courseid)
                    chosinCourse = Course.findOne(id: courseid)
                //    print(chosinCourse)
                    courseChooseBtn.setTitle(chosinCourse?.name, for: .normal)
                    
                    
                }
            }
            }else if pickerTableView.identifier == "TaskType"{
                for typeList in pickerTableView.items{
                    if typeList.checked == true{
                        taskType = TaskType.init(rawValue: typeList.identifier)
                        print(taskType)
                        taskTypeBtn.setTitle(taskType?.rawValue, for: .normal)
                    }
                    
                }
                
            }
            
        }
    
        
    }
    
    
    
    //viewController.unwindSegueIdentifier = "unwindAddTask"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tasksFiltersController = segue.destination as? PickerTableViewController{
            tasksFiltersController.unwindSegueIdentifier = "unwindAddTask"
            if segue.identifier == "SelectCourseAddTaskSegue" {
                        tasksFiltersController.title = "Course"
                tasksFiltersController.identifier = "CourseChoose"
                tasksFiltersController.multiSelect = false
                
                        
                        for course in Course.findAll() {
                            var pickerItem = PickerItem(identifier: course.id.uuidString, label: course.name, checked: false)
                            /*if currentCourse == course {
                                pickerItem.checked = true
                            }*/
                            
                            tasksFiltersController.items.append(pickerItem)
                        }
                        } else if segue.identifier == "SelectTaskTypeAddTaskSegue" {
                        tasksFiltersController.title = "Task Type"
                        tasksFiltersController.identifier = "TaskType"
                        tasksFiltersController.multiSelect = false
    
                        for taskType in TaskType.allCases {
        var pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.rawValue, checked: false)
        /*if currentCourse == course {
            pickerItem.checked = true
        }*/
        
        tasksFiltersController.items.append(pickerItem)
    }
    
    
}
            
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



}
}
