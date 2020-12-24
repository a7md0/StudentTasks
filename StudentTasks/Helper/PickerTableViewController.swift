//
//  PickerTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/24/20.
//

import UIKit

struct PickerItem {
    var identifier: String
    var label: String
    var checked: Bool
}

class PickerTableViewController: UITableViewController {
    
    var identifier: String?
    var items: [PickerItem] = []
    var multiSelect: Bool = false
    
    var unwindSegueIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        done()
    }
    
    func done() {
        if let unwindSegueIdentifier = self.unwindSegueIdentifier {
            performSegue(withIdentifier: unwindSegueIdentifier, sender: self)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemPickCell", for: indexPath)

        // Configure the cell...
        let item = items[indexPath.row]
        cell.textLabel?.text = item.label
        cell.accessoryType = item.checked ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if multiSelect == true {
            items[indexPath.row].checked = !items[indexPath.row].checked
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            if items[indexPath.row].checked == false {
                for index in items.indices {
                    items[index].checked = false
                }
                items[indexPath.row].checked = true
                
                tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
