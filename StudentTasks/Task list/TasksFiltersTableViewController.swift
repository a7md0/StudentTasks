//
//  TasksFiltersTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/24/20.
//

import UIKit

class TasksFiltersTableViewController: UITableViewController {

    var sort: TasksSort?
    var filters: TasksFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "taskTypeSegue",
           let tasksFiltersController = segue.destination as? TasksFiltersTableViewController {
            
        } else if segue.identifier == "courseSegue",
            let tasksFiltersController = segue.destination as? TasksFiltersTableViewController {
            
        } else if segue.identifier == "completenessSegue",
            let tasksFiltersController = segue.destination as? TasksFiltersTableViewController {
            
        }
    }
}
