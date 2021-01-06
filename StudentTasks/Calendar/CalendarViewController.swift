//
//  CalendarViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/2/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController
{
    var tasks: [Task] = []
    var taskByDate: [Task] = []
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = Task.findAll()
        
        setupFSCalendar()
        setupTasksTableView()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskDetailsTableViewController {
            destination.task = taskByDate[(taskTableView.indexPathForSelectedRow?.row)!]
        }
    }
}


extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func setupFSCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
        
        /*calendarView.reloadData()
         calendarView.select(calendarView.today)*/
        self.tableViewFilterTasksByDate(date: Date())
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var numberOfEvents = 0
        
        for task in tasks {
            let compareDate = Calendar.current.compare(task.dueDate, to: date, toGranularity: .day) // compare date based on same day (without time)
            
            if compareDate == .orderedSame {
                numberOfEvents += 1
            }
        }
        
        return numberOfEvents
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("Page Changed")
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        self.tableViewFilterTasksByDate(date: date)
        /*taskByDate = []
         
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
         taskTableView.reloadData()*/
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTasksTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        taskTableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskByDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateTask = taskByDate[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier") as! TasksTableViewCell
        
        // Configure the cell...
        cell.taskLabel.text = dateTask.name
        cell.subtitle.text = dateTask.brief
        
        if let codableColor = dateTask.course?.color {
            cell.courseImage.backgroundColor = codableColor.color
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DateTaskSegue", sender: self)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }
    
    func tableViewFilterTasksByDate(date: Date) {
        taskByDate = []
        
        for task in tasks {
            let compareDate = Calendar.current.compare(task.dueDate, to: date, toGranularity: .day) // compare date based on same day (without time)
            
            if compareDate == .orderedSame {
                taskByDate.append(task)
            }
        }
        
        taskTableView.reloadData()
        
        if taskByDate.count == 0 {
            taskTableView.backgroundView = noDataView
        } else {
            taskTableView.backgroundView = nil
        }
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
    
    func completeItem(indexPath: IndexPath) {
        var task = taskByDate[indexPath.row]
        
        task.complete(completedOn: nil)
    }
    
    func deleteItem(indexPath: IndexPath) {
        var task = taskByDate[indexPath.row]
        
        taskByDate.remove(at: indexPath.row)
        taskTableView.deleteRows(at: [indexPath], with: .left)
        
        task.remove()
    }
}
