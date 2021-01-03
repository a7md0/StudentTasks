//
//  AddTaskTableViewController.swift
//  StudentTasks
//
//  Created by Sayed Ali on 12/25/20.
//

import UIKit

class AddTaskTableViewController: UITableViewController {
    var course: Course?
    var taskType: TaskType?
    var taskpriority:TaskPriority?
    
    //IBOut
    
    @IBOutlet weak var taskNameField: UITextField!
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var taskTypeLabel: UILabel!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var prtiotySegment: UISegmentedControl!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var gradedTaskSwitch: UISwitch!
    @IBOutlet weak var contributionTextField: UITextField!
    @IBOutlet weak var gradeTypeSegment: UISegmentedControl!
    @IBOutlet weak var awardedGrade: UITextField!
    
    @IBOutlet weak var savebtn: UIBarButtonItem!
    
    var expandedCells: [String : Bool] = [
        "dueDateCell": false,
        "descriptionCell": false,
    ]
    
    var hiddenCells: [String : Bool] = [
        "gradeTypeCell": true,
        "contributionCell": true,
        "gradeCell": true,
    ]
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if(prtiotySegment.selectedSegmentIndex == 0){taskpriority = .low}
        else if(prtiotySegment.selectedSegmentIndex == 1){taskpriority = .normal}
        else if(prtiotySegment.selectedSegmentIndex == 2){taskpriority = .high}
        
        var task = Task.init(name: taskNameField.text!, description: descriptionTextField.text!, type: taskType!, priority: taskpriority!, dueDate: dueDatePicker.date)
        task.course = course!
        task.create()
        //print(chosinCourse)
        print(task.name)
        print(task)
        performSegue(withIdentifier: "unwindtoTaskfromAdd", sender: self)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonState()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.keyboardDismissMode = .interactive // Support keyboard hide by swipe
        
        dueDatePicker.date.addTimeInterval(3600 * 24 * 7)
        updateDatePickerLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func gradedSwitch(_ sender: UISwitch) {
        hiddenCells["gradeTypeCell"] = !sender.isOn
        hiddenCells["contributionCell"] = !sender.isOn
        hiddenCells["gradeCell"] = !sender.isOn
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateSaveButtonState() {
        guard let taskName = taskNameField.text,
              taskName.count > 2,
              course != nil,
              taskType != nil else {
            
            savebtn.isEnabled = false
            return
        }
        
        savebtn.isEnabled = true
        
    }
    
    func updateDatePickerLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dueDateLabel.text = formatter.string(from: dueDatePicker.date)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    @IBAction func dueDatePickerChanged(_ sender: UIDatePicker) {
        updateDatePickerLabel()
    }
    
    @IBAction func textFieldDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

// MARK: - Table view data source
extension AddTaskTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        if let cell = tableView.cellForRow(at: indexPath),
           let reuseIdentifier = cell.reuseIdentifier,
           expandedCells.keys.contains(reuseIdentifier) {
            
            let state = expandedCells[reuseIdentifier]!
            
            for (key, _) in expandedCells {
                expandedCells[key] = false
            }
            
            expandedCells[reuseIdentifier] = !state
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(164)
        let hiddenCellHeight = CGFloat(0)
        
        if let cell = tableView.cellForRow(at: indexPath),
           let reuseIdentifier  = cell.reuseIdentifier {
            
            if let expanded = expandedCells[reuseIdentifier] {
                return expanded ? largeCellHeight : normalCellHeight
            }
            
            if let hidden = hiddenCells[reuseIdentifier]  {
                return hidden ? hiddenCellHeight : normalCellHeight
            }
        }
        
        return normalCellHeight
    }
}

// MARK: - Navigation
extension AddTaskTableViewController {
    @IBAction func unwindtoAddtask(_ sender: UIStoryboardSegue) {
        if sender.identifier == "unwindAddTask",
           let pickerTableView = sender.source as? PickerTableViewController {
            if pickerTableView.identifier == "addTaskPickCourse"{
                for courselist in pickerTableView.items {
                    if courselist.checked == true,
                       let course = Course.findOne(id: courselist.identifier) {
                        courseLabel.text = course.name
                        
                        self.course = course
                        updateSaveButtonState()
                    }
                }
            } else if pickerTableView.identifier == "addTaskPickTaskType" {
                for typeList in pickerTableView.items {
                    if typeList.checked == true,
                       let taskType = TaskType.init(rawValue: typeList.identifier) {
                        taskTypeLabel.text = taskType.rawValue
                        
                        self.taskType = taskType
                        updateSaveButtonState()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pickerTableView = segue.destination as? PickerTableViewController {
            pickerTableView.identifier = segue.identifier
            pickerTableView.multiSelect = false
            pickerTableView.unwindSegueIdentifier = "unwindAddTask"
            
            if segue.identifier == "addTaskPickCourse" {
                pickerTableView.title = "Course"
                
                for course in Course.findAll() {
                    let pickerItem = PickerItem(identifier: course.id.uuidString, label: course.name, checked: false)
                    
                    pickerTableView.items.append(pickerItem)
                }
            } else if segue.identifier == "addTaskPickTaskType" {
                pickerTableView.title = "Task Type"
                
                for taskType in TaskType.allCases {
                    let pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.rawValue, checked: false)
                    
                    pickerTableView.items.append(pickerItem)
                }
            }
            
        }
    }
}

