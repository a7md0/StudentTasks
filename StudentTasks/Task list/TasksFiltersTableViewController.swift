//
//  TasksFiltersTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/24/20.
//

import UIKit

class TasksFiltersTableViewController: UITableViewController {

    var query: TasksQuery = TasksQuery.instance
    
    static var pcikerUnwindSegueIdentifier: String = "tasksFiltersUnwindSegue"
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var importancelabel: UILabel!
    
    @IBOutlet weak var taskTypeLabel: UILabel!
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
        query.sortBy.restoreDefault()
        query.filterBy.restoreDefault()
        
        updateView()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.query.save()
        
        performSegue(withIdentifier: "tasksViewUnwindSegue", sender: self)
    }
    
    func updateView() {
        dueDateLabel.text = query.sortBy.dueDate.rawValue
        importancelabel.text = query.sortBy.importance.rawValue
        
        taskTypeLabel.text = query.filterBy.taskTypes.count == query.filterBy.defaultTaskTypes.count ? "All" : "Custom"
        taskStatusLabel.text = query.filterBy.taskStatus.count == query.filterBy.defaultTaskStatus.count ? "All" : "Custom"
    }
    
    func handlePickerSelectionUpdate(identifier: String?, items: [PickerItem]) {
        guard let identifier = identifier else { return }
        
        switch identifier {
        case "taskTypeSegue":
            query.filterBy.taskTypes = []
            
            items.filter { $0.checked }.forEach { (item) in
                if let taskType = TaskType(rawValue: item.identifier) {
                    query.filterBy.taskTypes.append(taskType)
                }
            }
        case "taskStatusSegue":
            query.filterBy.taskStatus = []
            
            items.filter { $0.checked }.forEach { (item) in
                if let taskStatus = TaskStatus(rawValue: item.identifier) {
                    query.filterBy.taskStatus.append(taskStatus)
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
                
                for orderByCase in OrderBy.allCases {
                    alert.addAction(UIAlertAction(title: orderByCase.rawValue, style: .default, handler: { (UIAlertAction) in
                        self.query.sortBy.dueDate = orderByCase
                        self.updateView()
                    }))
                }
            case "priorityCell":
                alert.title = "Priority sorting"
                
                for priortyCase in Priorty.allCases {
                    alert.addAction(UIAlertAction(title: priortyCase.rawValue, style: .default, handler: { (UIAlertAction) in
                        self.query.sortBy.importance = priortyCase
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

        if let tasksFiltersController = segue.destination as? PickerTableViewController {
            
            tasksFiltersController.identifier = segue.identifier
            tasksFiltersController.unwindSegueIdentifier = TasksFiltersTableViewController.pcikerUnwindSegueIdentifier
            
            if segue.identifier == "taskTypeSegue" {
                tasksFiltersController.title = "Task type"
                tasksFiltersController.identifier = segue.identifier
                tasksFiltersController.multiSelect = true
                
                for taskType in query.filterBy.defaultTaskTypes {
                    var pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.rawValue, checked: false)
                    if query.filterBy.taskTypes.contains(taskType) {
                        pickerItem.checked = true
                    }
                    
                    tasksFiltersController.items.append(pickerItem)
                }
            } else if segue.identifier == "taskStatusSegue"  {
                tasksFiltersController.title = "Task status"
                tasksFiltersController.multiSelect = true
                
                for completenessStatus in query.filterBy.defaultTaskStatus {
                    var pickerItem = PickerItem(identifier: completenessStatus.rawValue, label: completenessStatus.rawValue, checked: false)
                    if query.filterBy.taskStatus.contains(completenessStatus) {
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
