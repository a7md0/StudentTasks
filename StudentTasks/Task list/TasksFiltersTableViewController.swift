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
    
    static var pcikerUnwindSegueIdentifier: String = "tasksFiltersUnwindSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateView()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIBarButtonItem) {
        filters?.restoreDefault()
        sort?.restoreDefault()
        
        updateView()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "tasksViewUnwindSegue", sender: self)
    }
    
    func updateView() {
        
    }
    
    func handlePickerSelectionUpdate(identifier: String?, items: [PickerItem]) {
        guard let identifier = identifier,
              let filters = filters else { return }
        
        switch identifier {
        case "taskTypeSegue":
            filters.taskTypes = []
            
            items.filter { $0.checked }.forEach { (item) in
                if let taskType = TaskType(rawValue: item.identifier) {
                    filters.taskTypes.append(taskType)
                }
            }
        case "courseSegue":
            filters.courses = []
            
            items.filter { $0.checked }.forEach { (item) in
                if let course = Course.findOne(id: item.identifier) {
                    filters.courses.append(course)
                }
            }
        case "completenessSegue":
            filters.completeness = []
            
            items.filter { $0.checked }.forEach { (item) in
                if let taskStatus = TaskStatus(rawValue: item.identifier) {
                    filters.completeness.append(taskStatus)
                }
            }
        default:
            return
        }
        
        updateView()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let tasksFiltersController = segue.destination as? PickerTableViewController,
           let filters = filters {
            
            tasksFiltersController.identifier = segue.identifier
            tasksFiltersController.unwindSegueIdentifier = TasksFiltersTableViewController.pcikerUnwindSegueIdentifier
            
            if segue.identifier == "taskTypeSegue" {
                tasksFiltersController.title = "Task type"
                tasksFiltersController.identifier = segue.identifier
                tasksFiltersController.multiSelect = true
                
                for taskType in filters.defaultTaskTypes {
                    var pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.rawValue, checked: false)
                    if filters.taskTypes.contains(taskType) {
                        pickerItem.checked = true
                    }
                    
                    tasksFiltersController.items.append(pickerItem)
                }
            } else if segue.identifier == "courseSegue"  {
                tasksFiltersController.title = "Course"
                tasksFiltersController.multiSelect = false
                
                for course in filters.defaultCourses {
                    var pickerItem = PickerItem(identifier: course.id.uuidString, label: course.name, checked: false)
                    if filters.courses.contains(course) {
                        pickerItem.checked = true
                    }
                    
                    tasksFiltersController.items.append(pickerItem)
                }
            } else if segue.identifier == "completenessSegue"  {
                tasksFiltersController.title = "Completeness"
                tasksFiltersController.multiSelect = true
                
                for completenessStatus in filters.defaultCompleteness {
                    var pickerItem = PickerItem(identifier: completenessStatus.rawValue, label: completenessStatus.rawValue, checked: false)
                    if filters.completeness.contains(completenessStatus) {
                        pickerItem.checked = true
                    }
                    
                    tasksFiltersController.items.append(pickerItem)
                }
            }
        }
    }
    
    @IBAction func unwindToTasksFiltersView(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        if unwindSegue.identifier == TasksFiltersTableViewController.pcikerUnwindSegueIdentifier,
           let pickerTableView = unwindSegue.source as? PickerTableViewController {
            handlePickerSelectionUpdate(identifier: pickerTableView.identifier, items: pickerTableView.items)
        }
    }
}
