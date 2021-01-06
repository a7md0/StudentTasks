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
    // Declaring Variables
    var tasks: [Task] = []
    var taskByDate: [Task] = []
    // refrencing FScalendar Library
    @IBOutlet weak var calendarView: FSCalendar!
    //refrencing tableView
    @IBOutlet weak var taskTableView: UITableView!
    // refrenicng View for whem there is no task for that date
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
    //Setup FsCalendar delegate and datasource
    func setupFSCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
        
        /*calendarView.reloadData()
         calendarView.select(calendarView.today)*/
        self.tableViewFilterTasksByDate(date: Date())
    }
    // Adding Task indecator for dates with dynamic number of dots
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
    // Updatng the table view for when user click on date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        self.tableViewFilterTasksByDate(date: date)

    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    // Setup table delegate and datasourse
    func setupTasksTableView() {
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        taskTableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
    }
    // returning the exact number of rows from the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskByDate.count
    }
    //Configuring the cell and insert the data in it
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
    // segue for when uer click on a task
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DateTaskSegue", sender: self)
    }
    // Adding the Delete and Complete Buttons from Swipe action
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
    // Configuring the Task Row Hight
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(72)
    }
    // filtering task by dates
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
    // Configuring the alert when deleting and canceling
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
    // completing the task
    func completeItem(indexPath: IndexPath) {
        var task = taskByDate[indexPath.row]
        
        task.complete(completedOn: nil)
    }
    // deleting the task from task array
    func deleteItem(indexPath: IndexPath) {
        var task = taskByDate[indexPath.row]
        
        taskByDate.remove(at: indexPath.row)
        taskTableView.deleteRows(at: [indexPath], with: .left)
        
        task.remove()
    }
}
