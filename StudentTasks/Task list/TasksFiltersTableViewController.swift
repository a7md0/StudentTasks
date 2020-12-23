//
//  TasksFiltersTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/24/20.
//

import UIKit

class TasksFiltersTableViewController: UITableViewController {

    var sort: TasksSort?
    var filters: TasksFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "tasksViewUnwindSegue", sender: self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "tasksViewUnwindSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let tasksFiltersController = segue.destination as? PickerTableViewController {
            tasksFiltersController.unwindSegueIdentifier = "tasksFiltersUnwindSegue"
            
            if segue.identifier == "taskTypeSegue" {
                tasksFiltersController.title = "Task type"
                tasksFiltersController.items = [
                    PickerItem(identifier: "1", label: "test", checked: true),
                    PickerItem(identifier: "2", label: "test", checked: true),
                    PickerItem(identifier: "3", label: "test", checked: true),
                ]
                tasksFiltersController.multiSelect = true
            } else if segue.identifier == "courseSegue"  {
                tasksFiltersController.title = "Course"
                tasksFiltersController.items = [
                    PickerItem(identifier: "1", label: "test", checked: true),
                    PickerItem(identifier: "2", label: "test", checked: false),
                    PickerItem(identifier: "3", label: "test", checked: false),
                ]
                tasksFiltersController.multiSelect = false
            } else if segue.identifier == "completenessSegue"  {
                tasksFiltersController.title = "Completeness"
                tasksFiltersController.items = [
                    PickerItem(identifier: "1", label: "test", checked: true),
                    PickerItem(identifier: "2", label: "test", checked: true),
                    PickerItem(identifier: "3", label: "test", checked: true),
                ]
                tasksFiltersController.multiSelect = true
            }
        }
    }
    
    @IBAction func unwindToTasksFiltersView(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        if unwindSegue.identifier == "tasksFiltersUnwindSegue" {
            
        }
    }
}
