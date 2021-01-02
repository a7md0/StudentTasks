//
//  TasksTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/16/20.
//

import UIKit

class TasksTableViewController: UITableViewController {

    private var isSearching: Bool = false
    
    var course: Course?
    private var allTasks: [Task] = []
    private var tasks: [Task] = []
    private var searchTasks: [Task] = []
    
    var query: TasksQuery = TasksQuery.instance
    
    var ignoreNextUpdate: Bool = false
    
    var reloadTableViewData: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
        tableView.keyboardDismissMode = .interactive // Support keyboard hide by swipe
        
        reloadTableViewData = debounce(interval: 250, queue: DispatchQueue.main, action: {
            self.tableView.reloadData()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.queryUpdated), name: Constants.tasksQueryNotifcations["updated"]!, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func queryUpdated(notification: NSNotification) {
        DispatchQueue.global(qos: .background).async {
            guard let query = notification.object as? TasksQuery else { return }
            
            self.query = query
            
            self.filterSortTasks()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setTasks(tasks: [Task], reloadData: Bool = true) {
        DispatchQueue.global(qos: .background).async {
            self.allTasks = tasks
        
            guard self.ignoreNextUpdate == false else {
                self.ignoreNextUpdate = true
                return
            }

            self.filterSortTasks()

            if reloadData {
                DispatchQueue.main.async {
                    self.reloadTableViewData?()
                }
            }
        }
    }
    
    func filterSortTasks() {
        self.tasks = allTasks.filter({ (task) -> Bool in
            var keep = false
            
            if query.filterBy.taskTypes.contains(task.type) && query.filterBy.taskStatus.contains(task.status) {
                keep = true
            }
            
            return keep
        })
        
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
        
        self.tasks.sort(by: {
            let compareDate = Calendar.current.compare($0.dueDate, to: $1.dueDate, toGranularity: .day) // compare date based on same day (without time)
            
            if compareDate != .orderedSame { // if the same-day comparision result isn't the same
                if query.sortBy.dueDate == .descending { // based on the filters sorting (user changeable)
                    return compareDate == .orderedDescending
                } else {
                    return compareDate == .orderedAscending
                }
            }
            
            // if the date compare result is the same (compareDate == .orderedSame)
            if $0.priority != $1.priority { // if the priorty isn't the same
                if query.sortBy.importance == .highest { // based on the filters sorting (user changeable)
                    return $0.priority > $1.priority // > descending
                } else {
                    return $0.priority < $1.priority // < ascending
                }
            }
            
            // if the priroity match too ($0.priority == $1.priority)
            if query.sortBy.dueDate == .descending {  // based on the filters sorting (user changeable)
                return $0.dueDate > $1.dueDate // > descending
            } else {
                return $0.dueDate < $1.dueDate // < ascending
            }
        })
    }
    
    func filtersChanged() {
        filterSortTasks()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTaskDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskDetailsTableViewController {
            destination.tasks = tasks[(tableView.indexPathForSelectedRow?.row)!]
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func completeItem(indexPath: IndexPath) {
        var task = tasks[indexPath.row]
        
        task.complete(completedOn: nil)
    }

    func deleteItem(indexPath: IndexPath) {
        var task = tasks[indexPath.row]
        
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        ignoreNextUpdate = true
        task.remove()
    }
}

// MARK: - Table view data source
extension TasksTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching == false ? tasks.count : searchTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier", for: indexPath) as! TasksTableViewCell

        // Configure the cell...
        let task = isSearching == false ? tasks[indexPath.row] : searchTasks[indexPath.row]
        cell.taskLabel.text = task.name
        cell.subtitle.text = task.brief

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
    @IBAction func TaskTableView(_ sender: UIStoryboardSegue){ }

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
            
            self.completeItem(indexPath: indexPath)
        }
        complete.backgroundColor = .gray
        complete.image = UIImage(systemName: "checkmark")
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let task = self.tasks[indexPath.row]
            
            self.showConfirmDelete(task.name) { (delete) in
                completionHandler(true)
                
                if delete {
                    print("Delete \(indexPath.row + 1)")
                
                    self.deleteItem(indexPath: indexPath)
                }
            }
        }
        delete.image = UIImage(systemName: "trash")
        
        let swipe = UISwipeActionsConfiguration(actions: [complete, delete])
        
        return swipe
    }
    
    func showConfirmDelete(_ what: String, handler: ((Bool) -> Void)?) {
        let confirmAlert = UIAlertController(title: "Delete \"\(what)\"?", message: "Deleting this task will delete all related data.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            handler?(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            handler?(false)
        }
        
        confirmAlert.addAction(okAction)
        confirmAlert.addAction(cancelAction)

        present(confirmAlert, animated: true, completion: nil)
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
}

extension TasksTableViewController {
    func filterSearchResult(searchQuery: String?) {
        DispatchQueue.global(qos: .background).async {
            if let searchQuery = searchQuery {
                print("searchQuery: \(searchQuery)")
                self.isSearching = true
                
                self.searchTasks = self.tasks.filter({ (task: Task) -> Bool in
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
                self.isSearching = false
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
