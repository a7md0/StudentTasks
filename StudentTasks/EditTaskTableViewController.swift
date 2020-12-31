//
//  EditTaskTableViewController.swift
//  StudentTasks
//
//  Created by Sayed Ali on 12/30/20.
//

import UIKit

class EditTaskTableViewController: UITableViewController {
    
    var tasks: Task?
    var chosinCourse: Course?
    var taskType: TaskType?
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskTypeBtn: UIButton!
    @IBOutlet weak var courseBrn: UIButton!
    @IBOutlet weak var gradingTypeSegment: UISegmentedControl!
    @IBOutlet weak var gradingContribution: UITextField!
    @IBOutlet weak var gradingSystemSwitch: UISwitch!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    @IBAction func GradingChanged(_ sender: Any) {
    updateSaveButtonState()
        if (gradingSystemSwitch.isOn == false){
            gradingContribution.isEnabled = false
        }
        else if (gradingSystemSwitch.isOn == true)
        {
            gradingContribution.isEnabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(editsavebtnClicked))
        navigationItem.title = "Edit"
        taskNameTextField.text = tasks?.name
               courseBrn.setTitle(tasks?.course?.name, for: .normal)
               taskTypeBtn.setTitle(tasks?.type.rawValue, for: .normal)
               if (tasks?.priority.rawValue == "Low"){prioritySegment.selectedSegmentIndex = 0}
               else if (tasks?.priority.rawValue == "Normal"){prioritySegment.selectedSegmentIndex = 1}
               else if (tasks?.priority.rawValue == "High"){prioritySegment.selectedSegmentIndex = 2}
                datePicker.date = tasks?.dueDate ?? Date()
               descriptionTextView.text = tasks?.description
               
               if (tasks?.graded == true)
               {
                   gradingSystemSwitch.isOn = true
                   gradingContribution.text = "\(tasks?.gradeContribution)"
                   if (tasks?.gradeType?.rawValue == "Main Task"){gradingTypeSegment.selectedSegmentIndex = 0}
                   if (tasks?.gradeType?.rawValue == "Course Total"){gradingTypeSegment.selectedSegmentIndex = 1}
               }
               if (tasks?.graded == false){gradingSystemSwitch.isOn = false}
        updateSaveButtonState()
        
        //print(tasks)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc func editsavebtnClicked()
    {
        if (taskType != nil){tasks?.type = taskType!}
            tasks?.name = taskNameTextField.text!
            tasks?.description = descriptionTextView.text!
            if(prioritySegment.selectedSegmentIndex == 0){tasks?.priority = .low}
            else if(prioritySegment.selectedSegmentIndex == 1){tasks?.priority = .normal}
            else if(prioritySegment.selectedSegmentIndex == 2){tasks?.priority = .high}
            
            if(gradingSystemSwitch.isOn == true)
            {
                var contr = gradingContribution.text!
                tasks?.graded = true
                tasks?.gradeContribution = Float(contr)!
                if (gradingTypeSegment.selectedSegmentIndex == 0){tasks?.gradeType = .mainTask}
                else if (gradingTypeSegment.selectedSegmentIndex == 1){tasks?.gradeType = .courseTotal}
            }
        tasks?.dueDate = datePicker.date
        print(tasks?.dueDate)
        print(datePicker.date)
            tasks?.save()
        performSegue(withIdentifier: "unwindToTaskDetailsedit", sender: self)
    }
    
    

    // MARK: - Table view data source
    func updateSaveButtonState() {
        var contribution:String?
        if (gradingSystemSwitch.isOn == true){
            if gradingContribution.text != nil{
                contribution = gradingContribution.text}
            
        }
        else{}
            let taskName = taskNameTextField.text ?? ""
             //let taskTpecheck = taskTypeBtn.currentTitle
        
        navigationItem.rightBarButtonItem?.isEnabled = taskName.count > 2 && contribution != "" //&& taskTpecheck != "Select Task Type"
        
    }
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func unwindtoEditTask(_ sender: UIStoryboardSegue)
    {
         if sender.identifier == "unwindEditTask",
            let pickerTableView = sender.source as? PickerTableViewController
         {
             if pickerTableView.identifier == "CourseChooseEdit"
             {
                 var courseid: String
                 for courselist in pickerTableView.items
                 {
                     if courselist.checked == true
                     {
                         courseid = courselist.identifier
                         chosinCourse = Course.findOne(id: courseid)
                         courseBrn.setTitle(chosinCourse?.name, for: .normal)
                        
                     }
                 }
             }
             else if pickerTableView.identifier == "TaskTypeEdit"
             {
                 for typeList in pickerTableView.items
                 {
                     if typeList.checked == true
                     {
                             taskType = TaskType.init(rawValue: typeList.identifier)
                             taskTypeBtn.setTitle(taskType?.rawValue, for: .normal)
                     }
                 }
             }
         }
     }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tasksFiltersController = segue.destination as? PickerTableViewController{
            tasksFiltersController.unwindSegueIdentifier = "unwindEditTask"
            if segue.identifier == "SelectCourseEditTaskSegue" {
                        tasksFiltersController.title = "Course"
                tasksFiltersController.identifier = "CourseChooseEdit"
                tasksFiltersController.multiSelect = false
                
                
                        
                        for course in Course.findAll() {
                            var pickerItem = PickerItem(identifier: course.id.uuidString, label: course.name, checked: false)
                            if tasks?.course == course
                                {
                                    pickerItem.checked = true
                                }
                            
                            
                            tasksFiltersController.items.append(pickerItem)
                        }
                        } else if segue.identifier == "SelectTaskTypeEditSegue" {
                        tasksFiltersController.title = "Task Type"
                        tasksFiltersController.identifier = "TaskTypeEdit"
                        tasksFiltersController.multiSelect = false
    
                        for Tasktype in TaskType.allCases {
                            var pickerItem = PickerItem(identifier: Tasktype.rawValue, label: Tasktype.rawValue, checked: false)
                            if tasks?.type == Tasktype
                                {
                                    pickerItem.checked = true
                                }
        
        tasksFiltersController.items.append(pickerItem)
    }
    
    
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
