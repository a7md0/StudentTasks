//
//  ViewController.swift
//  StudentTasks
//
//  Created by mobileProg on 12/2/20.
import UIKit

class toDoTasksList{
    var title: String = ""
    var duedate: Date = Date()
    	
}

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var table: UITableView!

    
    private var tasks = [toDoTasksList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func AddTaskButtonTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "addTask") as? AddTaskViewController else{
            return
        }
    }
    // Mark: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    }
    



