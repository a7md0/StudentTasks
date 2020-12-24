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
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var importancelabel: UILabel!
    
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
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
        dueDateLabel.text = sort?.dueDate.rawValue
        importancelabel.text = sort?.importance.rawValue
        
        
        taskTypeLabel.text = filters?.taskTypes.count == filters?.defaultTaskTypes.count ? "All" : "Custom"
        courseLabel.text = filters?.courses.count == filters?.defaultCourses.count ? "All" : "Custom"
        taskStatusLabel.text = filters?.completeness.count == filters?.defaultCompleteness.count ? "All" : "Custom"
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0,
            let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.popoverPresentationController?.sourceView = self.view // ipad support
            
            switch identifier {
            case "dueDateCell":
                alert.title = "Due date sorting"
                
                for orderByCase in TasksSort.OrderBy.allCases {
                    alert.addAction(UIAlertAction(title: orderByCase.rawValue, style: .default, handler: { (UIAlertAction) in
                        self.sort?.dueDate = orderByCase
                        self.updateView()
                    }))
                }
            case "importanceCell":
                alert.title = "Importance sorting"
                
                for priortyCase in TasksSort.Priorty.allCases {
                    alert.addAction(UIAlertAction(title: priortyCase.rawValue, style: .default, handler: { (UIAlertAction) in
                        self.sort?.importance = priortyCase
                        self.updateView()
                    }))
                }
            default:
                return
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true) {}
        }
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
                tasksFiltersController.multiSelect = true
                
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
