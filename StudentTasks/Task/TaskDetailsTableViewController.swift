//
//  TaskDetailsTableViewController.swift
//  StudentTasks
//
//  Created by Sayed Ali on 12/29/20.
//

import UIKit

class TaskDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var contributionLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditbtnClicked))
    }
    
    @objc func EditbtnClicked(){
        self.performSegue(withIdentifier: "toEditTaskSegue", sender: self)
    }
    
    func reloadData() {
        guard let task = task,
              let course = task.course else { return }
        
        self.navigationItem.title = task.name
        
        taskNameLabel.text = task.name
        courseLabel.text = course.name
        taskTypeLabel.text = task.type.rawValue
        priorityLabel.text = task.priority.rawValue
        dueDateLabel.text = DateUtilities.dateFormatter.string(from: task.dueDate)
        
        descriptionTextView.text = task.description
        
        if task.grade.graded,
           let contribution = task.grade.contribution {
            
            contributionLabel.text = GradeUtilities.percentageFormatter.string(for: contribution)
            if let grade = task.grade.grade {
                if task.grade.mode == .percentage {
                    gradeLabel.text = GradeUtilities.percentageFormatter.string(for: grade)
                } else {
                    gradeLabel.text = "\(grade * contribution * 100)/\(contribution * 100)"
                }
            } else {
                gradeLabel.text = "Unset"
            }
        }
    }
    
    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskFormTableViewController,
           let task = self.task {
            destination.task = task
            destination.unwindSegue = "unwindToTaskDetailFromEdit"
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }*/
    @IBAction func unwindToTaskDetails(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if unwindSegue.identifier == "unwindToTaskDetailFromEdit",
           let addController = sourceViewController as? TaskFormTableViewController {
            task = addController.task
            reloadData()
        }
    }
}

/*
 https://stackoverflow.com/a/36003094/1738413
 KeithB
 */
extension TaskDetailsTableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return shouldHideSection(section: section) ? 0.1 : super.tableView(tableView, heightForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return shouldHideSection(section: section) ? 0.1 : super.tableView(tableView, heightForFooterInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return shouldHideSection(section: indexPath.section) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if shouldHideSection(section: section) {
            let headerView = view as! UITableViewHeaderFooterView
            headerView.textLabel!.textColor = UIColor.clear
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if shouldHideSection(section: section) {
            let footerView = view as! UITableViewHeaderFooterView
            footerView.textLabel!.textColor = UIColor.clear
        }
    }
    
    func shouldHideSection(section: Int) -> Bool {
        switch section {
        case 1:
            return (task?.grade.graded ?? false) ? false : true
        default:
            return false
        }
    }
}
