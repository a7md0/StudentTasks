//
//  NotificationsPreferencesTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/30/20.
//

import UIKit

class NotificationsPreferencesTableViewController: UITableViewController {

    var notificationSettings: NotificationSettings = NotificationSettings.instance
    
    @IBOutlet weak var beforeDeadlineLabel: UILabel!
    
    @IBOutlet weak var taskTypesLabel: UILabel!
    @IBOutlet weak var taskPrioritiesLabel: UILabel!
    
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    var isFromDatePickerHidden = true
    
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    var isToDatePickerHidden = true
    
    let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        updateView()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIBarButtonItem) {
        notificationSettings = NotificationSettings.reset()
        updateView()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        if toDatePicker.date <= fromDatePicker.date {
            toDatePicker.date = fromDatePicker.date.addingTimeInterval(300)
        }
        
        updateDateLabels()
        
        notificationSettings.preferredTimeRange.start = fromDatePicker.date
        notificationSettings.preferredTimeRange.end = toDatePicker.date
        notificationSettings.update()
    }
    
    func updateView() {
        loadSettings()
        updateDateLabels()
        updateTriggers()
        updateTasksFilters()
    }
    
    func loadSettings() {
        fromDatePicker.date = notificationSettings.preferredTimeRange.start
        toDatePicker.date = notificationSettings.preferredTimeRange.end
    }
    
    func updateDateLabels() {
        fromDateLabel.text = timeFormatter.string(from: fromDatePicker.date)
        toDateLabel.text = timeFormatter.string(from: toDatePicker.date)
    }
    
    func updateTriggers() {
        if let item  = Constants.daysMapping.first(where: { $0.key == notificationSettings.triggerBefore }) {
            beforeDeadlineLabel.text = item.value
        }
    }
    
    func updateTasksFilters() {
        taskTypesLabel.text = selectionString(notificationSettings.preferredTypes, with: TaskType.allCases)
        taskPrioritiesLabel.text = selectionString(notificationSettings.preferredPriorities, with: TaskPriority.allCases)
    }
    
    func selectionString(_ compare: Array<Any>, with: Array<Any>) -> String {
        switch compare.count {
        case 0:
            return NSLocalizedString("None", comment: "None")
        case with.count:
            return NSLocalizedString("All", comment: "All")
        default:
            return NSLocalizedString("Custom", comment: "Custom")
        }
    }
    
    func handleTriggerBeforeDeadlinePicker(items: [PickerItem]) {
        if let chosenItem = items.first(where: {$0.checked}),
           let value = Double(chosenItem.identifier) {
            notificationSettings.triggerBefore = value
        }
        
        notificationSettings.update()
        updateTriggers()
    }
    
    func handleTaskTypesPicker(items: [PickerItem]) {
        notificationSettings.preferredTypes = items.compactMap({ (item) -> TaskType? in
            return item.checked ? TaskType(rawValue: item.identifier) : nil
        })
        
        notificationSettings.update()
        updateTasksFilters()
    }
    
    func handleTaskPrioritiesPicker(items: [PickerItem]) {
        notificationSettings.preferredPriorities = items.compactMap({ (item) -> TaskPriority? in
            return item.checked ? TaskPriority(rawValue: Int(item.identifier)!) : nil
        })
        
        notificationSettings.update()
        updateTasksFilters()
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
        
        if let pickerTableView = segue.destination as? PickerTableViewController {
            pickerTableView.identifier = segue.identifier
            pickerTableView.unwindSegueIdentifier = "unwindNotificationsPreferences"
            
            if segue.identifier == "notificationTaskTriggerB4Segue" {
                pickerTableView.title = NSLocalizedString("Before deadline", comment: "Before deadline")
                pickerTableView.multiSelect = false
                
                for day in Constants.daysMapping {
                    var pickerItem = PickerItem(identifier: String(day.key), label: day.value, checked: false)
                    if notificationSettings.triggerBefore == day.key {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            } else if segue.identifier == "notificationTaskTypesSegue" {
                pickerTableView.title = NSLocalizedString("Task types", comment: "Task types")
                pickerTableView.multiSelect = true
                
                for taskType in TaskType.allCases {
                    var pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.description, checked: false)
                    if notificationSettings.preferredTypes.contains(taskType) {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            } else if segue.identifier == "notificationTaskPrioritiesSegue" {
                pickerTableView.title = NSLocalizedString("Task priorities", comment: "Task priorities")
                pickerTableView.multiSelect = true
                
                for taskPriority in TaskPriority.allCases {
                    var pickerItem = PickerItem(identifier: String(taskPriority.rawValue), label: taskPriority.description, checked: false)
                    if notificationSettings.preferredPriorities.contains(taskPriority) {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            }
        }
    }
    
    @IBAction func unwindToNotificationsPreferences(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if unwindSegue.identifier == "unwindNotificationsPreferences",
           let pickerView = sourceViewController as? PickerTableViewController {
            if pickerView.identifier == "notificationTaskTriggerB4Segue" {
                handleTriggerBeforeDeadlinePicker(items: pickerView.items)
            } else if pickerView.identifier == "notificationTaskTypesSegue" {
                handleTaskTypesPicker(items: pickerView.items)
            } else if pickerView.identifier == "notificationTaskPrioritiesSegue" {
                handleTaskPrioritiesPicker(items: pickerView.items)
            }
        }
    }
}
