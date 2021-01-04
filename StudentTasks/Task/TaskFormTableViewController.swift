//
//  AddTaskTableViewController.swift
//  StudentTasks
//
//  Created by Sayed Ali on 12/25/20.
//

import UIKit

class TaskFormTableViewController: UITableViewController {

    @IBOutlet weak var taskNameField: UITextField!
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var taskTypeLabel: UILabel!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var prtiotySegment: UISegmentedControl!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var gradedTaskSwitch: UISwitch!
    @IBOutlet weak var contributionLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
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
    
    var course: Course?
    var taskType: TaskType?
    var taskPriority: TaskPriority = .normal
    var gradeMode: GradeMode = .percentage
    var grade: TaskGrade = TaskGrade()
    
    var editMode = false
    var unwindSegue = "unwindtoTaskfromAdd"
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.keyboardDismissMode = .interactive // Support keyboard hide by swipe
        
        /*contributionTextField.delegate = self
        awardedGrade.delegate = self*/
        
        if let task = self.task {
            self.editMode = true
            
            navigationItem.title = task.name
            updateSelection()
        } else {
            dueDatePicker.date.addTimeInterval(3600 * 24 * 7)
        }
        
        updateSaveButtonState()
        updateDatePickerLabel()
        updateGradingCellsState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        guard let taskName = self.taskNameField.text,
              let descriptionText = self.descriptionTextField.text,
              let taskType = self.taskType,
              let course = self.course else { return }
        
        var task: Task
        
        if self.editMode,
           let orignalTask = self.task {
            
            task = orignalTask
            task.name = taskName
            task.description = descriptionText
            task.type = taskType
            task.priority = taskPriority
            task.dueDate = dueDatePicker.date
        } else {
            task = Task(name: taskName, description: descriptionText, type: taskType, priority: taskPriority, dueDate: dueDatePicker.date)
            task.course = course
        }
        
        // Marking system - collecting data
        /*task.grade.graded = gradedTaskSwitch.isOn
        if gradedTaskSwitch.isOn,
           let contributionText = self.contributionTextField.text,
           let contribution = Decimal(string: contributionText) {
            
            task.grade.contribution = contribution / 100
            task.grade = self.grade
            
            if let awardedGradeText = self.awardedGrade.text,
               let awardedGrade = Decimal(string: awardedGradeText) {
                
                if self.gradeMode == .percentage {
                    task.grade.grade = awardedGrade / 100
                } else {
                    task.grade.grade = awardedGrade / contribution
                }
            }
        }*/
        task.grade = self.grade
        
        if self.editMode {
            self.task = task
            task.save()
        } else {
            task.create()
        }

        performSegue(withIdentifier: self.unwindSegue, sender: self)
    }
    
    @IBAction func gradedSwitch(_ sender: UISwitch) {
        self.grade.graded = sender.isOn
        
        updateGradingCellsState()
    }
    
    @IBAction func prioritySegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            taskPriority = .low
        case 1:
            taskPriority = .normal
        case 2:
            taskPriority = .high
        default:
            taskPriority = .normal
        }
    }
    
    func updateGradingCellsState() {
        hiddenCells["gradeTypeCell"] = !gradedTaskSwitch.isOn
        hiddenCells["contributionCell"] = !gradedTaskSwitch.isOn
        hiddenCells["gradeCell"] = !gradedTaskSwitch.isOn
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateSelection() {
        guard let task = self.task else { return }
        
        self.taskType = task.type
        self.taskPriority = task.priority
        
        taskNameField.text = task.name
        
        if let course = task.course {
            courseLabel.text = course.name
            self.course = course
        }
        taskTypeLabel.text = task.type.rawValue
        
        dueDatePicker.date = task.dueDate
        
        switch task.priority {
        case .low:
            prtiotySegment.selectedSegmentIndex = 0
        case .normal:
            prtiotySegment.selectedSegmentIndex = 1
        case .high:
            prtiotySegment.selectedSegmentIndex = 2
        }
        
        descriptionTextField.text = task.description
        
        gradedTaskSwitch.isOn = task.grade.graded
        
        self.grade = task.grade
        
        updateGradingSection()
        
        updatePickerLabels()
    }
    
    func updateGradingSection() {
        if self.grade.graded {
            if let contribution = self.grade.contribution {
                contributionLabel.text = GradeUtilities.percentageFormatter.string(for: contribution)
            } else {
                contributionLabel.text = "Unset"
            }
            
            if let _ = self.grade.grade {
                gradeLabel.text = self.grade.formattedGrade
            } else {
                gradeLabel.text = "Unset"
            }
        }
        
        updateGradingCellsState()
    }
    
    func updatePickerLabels() {
        if let course = self.course {
            courseLabel.text = course.name
        }
        
        if let taskType = self.taskType {
            taskTypeLabel.text = taskType.rawValue
        }
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
        dueDateLabel.text = DateUtilities.dateFormatter.string(from: dueDatePicker.date)
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
    
    func promptForContribution() {
        let alert = GradeUtilities.promptContribution(grade: self.grade, callback: { (contribution) in
            self.grade.contribution = contribution
            
            self.updateGradingSection()
        })
        
        self.present(alert, animated: true)
    }
    
    func promptForGrade() {
        let alert = GradeUtilities.gradePrompt(grade: self.grade) { (mode, grade) in
            self.grade.mode = mode ?? .percentage
            self.grade.grade = grade
            
            self.updateGradingSection()
        }
        
        self.present(alert, animated: true)
    }
}

// MARK: - Table view data source
extension TaskFormTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        
        if let cell = tableView.cellForRow(at: indexPath),
           let reuseIdentifier = cell.reuseIdentifier {
            if expandedCells.keys.contains(reuseIdentifier) {
                let state = expandedCells[reuseIdentifier]!
                
                for (key, _) in expandedCells {
                    expandedCells[key] = false
                }
                
                expandedCells[reuseIdentifier] = !state
                if reuseIdentifier == "dueDateCell" {
                    dueDatePicker.isUserInteractionEnabled = expandedCells[reuseIdentifier]!
                } else if reuseIdentifier == "descriptionCell" {
                    descriptionTextField.isUserInteractionEnabled = expandedCells[reuseIdentifier]!
                }
                
                
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            if reuseIdentifier == "courseCell", self.editMode == false {
                performSegue(withIdentifier: "addTaskPickCourse", sender: self)
            } else if reuseIdentifier == "contributionCell" {
                promptForContribution()
            } else if reuseIdentifier == "gradeCell" {
                promptForGrade()
            }
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
extension TaskFormTableViewController {
    @IBAction func unwindtoAddtask(_ sender: UIStoryboardSegue) {
        if sender.identifier == "unwindAddTask",
           let pickerTableView = sender.source as? PickerTableViewController {
            if pickerTableView.identifier == "addTaskPickCourse"{
                for courselist in pickerTableView.items {
                    if courselist.checked == true,
                       let course = Course.findOne(id: courselist.identifier) {
                        
                        self.course = course
                    }
                }
            } else if pickerTableView.identifier == "addTaskPickTaskType" {
                for typeList in pickerTableView.items {
                    if typeList.checked == true,
                       let taskType = TaskType(rawValue: typeList.identifier) {
                        
                        self.taskType = taskType
                    }
                }
            }
            
            updatePickerLabels()
            updateSaveButtonState()
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
                    var pickerItem = PickerItem(identifier: course.id.uuidString, label: course.name, checked: false)
                    if let task = self.task, task.course == course {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            } else if segue.identifier == "addTaskPickTaskType" {
                pickerTableView.title = "Task Type"
                
                for taskType in TaskType.allCases {
                    var pickerItem = PickerItem(identifier: taskType.rawValue, label: taskType.rawValue, checked: false)
                    if let task = self.task, task.type == taskType {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            }
            
        }
    }
}

extension TaskFormTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.init(charactersIn: "0123456789./%")
        let characterSet = CharacterSet(charactersIn: string)
        
        if let text = textField.text {
            if [".", "/", "%"].contains(string), text.contains(string) {
                return false
            }
        }
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

