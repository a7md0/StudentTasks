//
//  CalendarViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/2/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var taskByDate: [Task] = []
    var ignoreNextUpdate: Bool = false
 //   var dateTasks : [Task]?
 //   var Tasks: Task?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskByDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateTask = taskByDate[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTaskCell") as! DateTaskTableViewCell
        cell.taskDetails(task: dateTask)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DateTaskSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskDetailsTableViewController {
            destination.tasks = taskByDate[(taskTableView.indexPathForSelectedRow?.row)!]
    }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = UIContextualAction(style: .normal, title: "Complete") { (action, view, completionHandler) in
            print("Complete \(indexPath.row + 1)")
            
            self.completeItem(indexPath: indexPath)
        }
        complete.backgroundColor = .gray
        complete.image = UIImage(systemName: "checkmark")
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let task = self.taskByDate[indexPath.row]
            
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
    let Formatter = DateFormatter()
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.reloadData()
        setupFSCalendar()
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    

    // MARK: - Navigation
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        taskByDate = []
        
        Formatter.dateStyle = .medium
        
        let SelectedDate = Formatter.string(from: date)
        
        print("Selected Date is: \(SelectedDate)")
        for task in Task.findAll()
        {
            var TaskDate = Formatter.string(from: task.dueDate)
            if (TaskDate == SelectedDate)
            {
                taskByDate.append(task)
            }
            
        }
        if(taskByDate.count != 0)
        {
            print(taskByDate)
        }
        taskTableView.reloadData()
    }
    func completeItem(indexPath: IndexPath) {
        var task = taskByDate[indexPath.row]
        
        task.complete(completedOn: nil)
    }

    func deleteItem(indexPath: IndexPath) {
        var task = taskByDate[indexPath.row]
        
        taskByDate.remove(at: indexPath.row)
        taskTableView.deleteRows(at: [indexPath], with: .left)
        
        ignoreNextUpdate = true
        task.remove()
    }
    
    
}





extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func setupFSCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
    }
}
