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
        print(task)
    }
    
    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditTaskTableViewController{
            destination.tasks = task!
        }
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }*/
    
    @IBAction func unwindToTaskDetails(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if unwindSegue.identifier == "unwindToTaskDetailsedit",
           let editController = sourceViewController as? EditTaskTableViewController
        {
            task = editController.tasks
            reloadData()
        }
    }
    
    
}
