//
//  TaskDetailsTableViewController.swift
//  StudentTasks
//
//  Created by Sayed Ali on 12/29/20.
//

import UIKit

class TaskDetailsTableViewController: UITableViewController {
    var tasks: Task?
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskCourse: UILabel!
    @IBOutlet weak var taskTypee: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var Contrivutionpersentage: UILabel!
    let dateformatted = DateFormatter();
    @IBOutlet weak var gradedType: UILabel!
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditbtnClicked))
        super.viewDidLoad()
        print(tasks?.course?.name)
        reloadData()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func EditbtnClicked(){
        self.performSegue(withIdentifier: "toEditTaskSegue", sender: self)
    }
    func reloadData(){
        dateformatted.dateFormat = "YYYY/MM/dd"
        var datee:String = dateformatted.string(from: tasks!.dueDate)
        self.navigationItem.title = tasks?.name
        taskName.text = tasks?.name
        taskCourse.text = tasks?.course?.name
        taskTypee.text = tasks?.type.rawValue
        priority.text = tasks?.priority.rawValue
        date.text = datee
        
        if tasks?.description != ""{
            descriptionTextView.text = tasks?.description
    }
        if (tasks?.grade.graded == true)
        {
            var contr = tasks?.grade.contribution
            Contrivutionpersentage.text = "\(contr)"
            gradedType.text = tasks?.grade.mode.rawValue
        } else {
            Contrivutionpersentage.text = ""
            gradedType.text = ""
        }
    }

    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditTaskTableViewController{
            destination.tasks = tasks!
        }
    }
    @IBAction func unwindToTaskDetails(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        if unwindSegue.identifier == "unwindToTaskDetailsedit",
           let editController = sourceViewController as? EditTaskTableViewController
        {
            tasks = editController.tasks
            reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
