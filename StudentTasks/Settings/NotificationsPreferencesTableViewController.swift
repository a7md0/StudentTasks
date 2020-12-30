//
//  NotificationsPreferencesTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/30/20.
//

import UIKit

class NotificationsPreferencesTableViewController: UITableViewController {

    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    var isFromDatePickerHidden = true
    
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    var isToDatePickerHidden = true
    
    
    @IBOutlet weak var taskTypesLabel: UILabel!
    @IBOutlet weak var taskPrioritiesLabel: UILabel!
    
    let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        updateDateLabels()
        updateTasksFilters()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateLabels()
    }
    
    func updateDateLabels() {
        fromDateLabel.text = timeFormatter.string(from: fromDatePicker.date)
        toDateLabel.text = timeFormatter.string(from: toDatePicker.date)
    }
    
    func updateTasksFilters() {
        
    }
    
    func handleTaskTypesPicker(items: [PickerItem]) {
        /*self.notificationTaskTypes = []
        
        items.filter { $0.checked }.forEach { (item) in
            if let taskType = TaskType(rawValue: item.identifier) {
                notificationTaskTypes.append(taskType)
            }
        }
        
        if let data = try? JSONEncoder().encode(notificationTaskTypes) {
            defaults.setValue(data, forKey: "notificationTaskTypes")
        }*/
    }
    
    func handleTaskPrioritiesPicker(items: [PickerItem]) {
        
    }
}

extension NotificationsPreferencesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath),
           ["fromTimeCell", "toTimeCell"].contains(cell.reuseIdentifier) {
            
            if cell.reuseIdentifier == "fromTimeCell" {
                isToDatePickerHidden = true
                isFromDatePickerHidden = !isFromDatePickerHidden
            } else if cell.reuseIdentifier == "toTimeCell" {
                isFromDatePickerHidden = true
                isToDatePickerHidden = !isToDatePickerHidden
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(164)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            switch (cell.reuseIdentifier) {
            case "fromTimeCell":
                return isFromDatePickerHidden ? normalCellHeight : largeCellHeight
            case "toTimeCell":
                return isToDatePickerHidden ? normalCellHeight : largeCellHeight
            default:
                return normalCellHeight
            }
        }
        
        return normalCellHeight
    }
}

// MARK: - Navigation
extension NotificationsPreferencesTableViewController {
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let tasksFiltersController = segue.destination as? PickerTableViewController {
            tasksFiltersController.identifier = segue.identifier
            tasksFiltersController.unwindSegueIdentifier = "unwindNotificationsPreferences"
            
            if segue.identifier == "notificationTaskTypesSegue" {
                tasksFiltersController.title = "Task types"
                tasksFiltersController.multiSelect = true
                
                for taskType in TaskType.allCases {
                    var pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.rawValue, checked: false)
                    /*if notificationTaskTypes.contains(taskType) {
                        pickerItem.checked = true
                    }*/
                    
                    tasksFiltersController.items.append(pickerItem)
                }
            } else if segue.identifier == "notificationTaskPrioritiesSegue" {
                tasksFiltersController.title = "Task priorities"
                tasksFiltersController.multiSelect = true
                
                for taskPriority in TaskPriority.allCases {
                    var pickerItem = PickerItem(identifier: taskPriority.rawValue, label: taskPriority.rawValue, checked: false)
                    /*if notificationTaskTypes.contains(taskPriority) {
                        pickerItem.checked = true
                    }*/
                    
                    tasksFiltersController.items.append(pickerItem)
                }
            }
        }
    }
    
    @IBAction func unwindToNotificationsPreferences(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if let pickerView = sourceViewController as? PickerTableViewController {
            if unwindSegue.identifier == "notificationTaskTypesSegue" {
                handleTaskTypesPicker(items: pickerView.items)
            } else if unwindSegue.identifier == "notificationTaskPrioritiesSegue" {
                handleTaskPrioritiesPicker(items: pickerView.items)
            }
        }
    }
}
