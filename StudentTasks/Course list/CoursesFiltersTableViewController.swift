//
//  CoursesFiltersTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/6/21.
//

import UIKit

class CoursesFiltersTableViewController: UITableViewController {

    var query: CoursesQuery = CoursesQuery.instance
    
    @IBOutlet weak var courseNameSortLabel: UILabel!
    @IBOutlet weak var numberOfSortLabel: UILabel!
    
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
        
        updateView()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.query.save()
        
        performSegue(withIdentifier: "coursesViewUnwindSegue", sender: self)
    }
    
    func updateView() {
        courseNameSortLabel.text = query.sortBy.courseName.description
        numberOfSortLabel.text = query.sortBy.numberOf.description
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0,
            let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.popoverPresentationController?.sourceView = self.view // ipad support
            
            switch identifier {
            case "sortCourseNameCell":
                alert.title = NSLocalizedString("Course name sorting", comment: "Sort by course name alphabeat")
                
                for orderByCase in OrderBy.allCases {
                    alert.addAction(UIAlertAction(title: orderByCase.description, style: .default, handler: { (UIAlertAction) in
                        self.query.sortBy.courseName = orderByCase
                        self.updateView()
                    }))
                }
            default:
                return
            }
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel))
            self.present(alert, animated: true) {}
        }
    }
    
    func handlePickerSelectionNumberOf(items: [PickerItem]) {
        items.filter { $0.checked }.forEach { (item) in
            if let taskStatus = TaskStatus(rawValue: Int(item.identifier)!) {
                query.sortBy.numberOf = taskStatus
            }
        }
        
        updateView()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let tasksFiltersController = segue.destination as? PickerTableViewController {
            
            tasksFiltersController.identifier = segue.identifier
            tasksFiltersController.unwindSegueIdentifier = "coursesFiltersUnwindSegue"
            
            if segue.identifier == "coursesNumberOfPickerSegue" {
                tasksFiltersController.title = NSLocalizedString("Number of", comment: "Number of")
                tasksFiltersController.identifier = segue.identifier
                tasksFiltersController.multiSelect = false
                
                for taskStatus in TaskStatus.allCases {
                    var pickerItem = PickerItem(identifier: String(taskStatus.rawValue), label: taskStatus.description, checked: false)
                    if query.sortBy.numberOf == taskStatus {
                        pickerItem.checked = true
                    }
                    
                    tasksFiltersController.items.append(pickerItem)
                }
            }
        }
    }
    
    @IBAction func unwindToCoursesFiltersView(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        if unwindSegue.identifier == "coursesFiltersUnwindSegue",
           let pickerTableView = sourceViewController as? PickerTableViewController {
            handlePickerSelectionNumberOf(items: pickerTableView.items)
        }
    }
}
