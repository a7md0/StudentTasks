//
//  EditTaskTableViewController.swift
//  StudentTasks
//
//  Created by Sayed Ali on 12/30/20.
//

import UIKit

class EditTaskTableViewController: UITableViewController {
    
    var tasks: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(editsavebtnClicked))
        navigationItem.title = "Edit"
        
        print(tasks)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc func editsavebtnClicked(){
        
    }
    
    

    // MARK: - Table view data source
    @IBAction func unwindtoEditTask(_ sender: UIStoryboardSegue){ }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tasksFiltersController = segue.destination as? PickerTableViewController{
            tasksFiltersController.unwindSegueIdentifier = "unwindEditTask"
            if segue.identifier == "SelectCourseEditTaskSegue" {
                        tasksFiltersController.title = "Course"
                tasksFiltersController.identifier = "CourseChooseEdit"
                tasksFiltersController.multiSelect = false
                
                        
                        for course in Course.findAll() {
                            var pickerItem = PickerItem(identifier: course.id.uuidString, label: course.name, checked: false)

                            
                            tasksFiltersController.items.append(pickerItem)
                        }
                        } else if segue.identifier == "SelectTaskTypeEditSegue" {
                        tasksFiltersController.title = "Task Type"
                        tasksFiltersController.identifier = "TaskTypeEdit"
                        tasksFiltersController.multiSelect = false
    
                        for taskType in TaskType.allCases {
                            var pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.rawValue, checked: false)

        
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
