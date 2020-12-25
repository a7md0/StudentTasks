//
//  TasksTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/16/20.
//

import UIKit

class TasksTableViewController: UITableViewController {

    private var isSearching: Bool = false
    
    private var tasks: [Task] = []
    private var searchTasks: [Task] = []
    
    var sort: TasksSort?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
        tableView.keyboardDismissMode = .interactive // Support keyboard hide by swipe
    }
    
    func setTasks(tasks: [Task]) {
        // Sortable by date withou time? Then importance level? maybe with little imporvment
        // Sortable by importance level then date time? The groupping is bad to show nearby due dates
        // Sortable by either date or importance? Not good enough
        
        /*
         Compare if the two tasks based on the same day (without time):
            if so: return whether "The left operand is greater than the right operand."
         else: compare based on priority
        
         Compare if the two takss priority isn't the same:
            if so: return whether the left task priority is less than the right one
         else: compare on full date (including time)
        */
        
        self.tasks = tasks.sorted(by: {
            let compareDate = Calendar.current.compare($0.dueDate, to: $1.dueDate, toGranularity: .day) // compare date based on same day (without time)
            
            if compareDate != .orderedSame { // if the same-day comparision result isn't the same
                if sort?.dueDate == .descending {
                    return compareDate == .orderedDescending
                } else {
                    return compareDate == .orderedAscending
                }
            }
            
            // if the date compare result is the same
            if $0.priority != $1.priority { // if the priorty isn't the same
                if sort?.importance == .highest {
                    return $0.priority > $1.priority // return whether the 1st priority is less than 2nd
                } else {
                    return !($0.priority > $1.priority)
                }
            }
                
            if sort?.dueDate == .descending {
                return $0.dueDate < $1.dueDate //return whether the 1st full date is less than the 2nd
            } else {
                return !($0.dueDate < $1.dueDate)
            }
        })
    }
    
    func filtersChanged() {
        self.setTasks(tasks: self.tasks)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching == false ? tasks.count : searchTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier", for: indexPath) as! TasksTableViewCell

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = .current

        // Configure the cell...
        let task = isSearching == false ? tasks[indexPath.row] : searchTasks[indexPath.row]
        cell.taskLabel.text = task.name
        cell.subtitle.text = dateFormatter.string(from: task.dueDate)
        if let imageData = task.course?.imageData {
            print("image data")
            cell.courseImage.image = UIImage(data: imageData)
        }
        if let codableColor = task.course?.color {
            cell.courseImage.backgroundColor = codableColor.color
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = UIContextualAction(style: .normal, title: "Complete") { (action, view, completionHandler) in
            print("Complete \(indexPath.row + 1)")
        }
        complete.backgroundColor = .gray
        complete.image = UIImage(systemName: "checkmark")
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            print("Delete \(indexPath.row + 1)")
            
            self.deleteItem(indexPath: indexPath)
        }
        delete.image = UIImage(systemName: "trash")
        
        let swipe = UISwipeActionsConfiguration(actions: [complete, delete])
        
        return swipe
    }

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

    func deleteItem(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        task.remove()
    }
}

extension TasksTableViewController {
    func filterResults(searchQuery: String?) {
        if let searchQuery = searchQuery {
            print("searchQuery: \(searchQuery)")
            isSearching = true
            
            searchTasks = tasks.filter({ (task: Task) -> Bool in
                var result = false
                
                let searchKeywords = searchQuery.lowercased().split(separator: " ")
                searchKeywords.forEach { (keyword) in
                    if task.name.lowercased().contains(keyword) || task.description.lowercased().contains(keyword) {
                        result = true
                        return // break loop
                    }
                }
                
                return result
            })
        } else {
            isSearching = false
        }
        
        tableView.reloadData()
    }
}
