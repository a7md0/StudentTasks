//
//  NotificationsPreferencesTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/30/20.
//

import UIKit

class NotificationsPreferencesTableViewController: UITableViewController {

    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    var isFromDatePickerHidden = true
    
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    var isToDatePickerHidden = true
    
    let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        updateDateLabels()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateLabels()
    }
    
    func updateDateLabels() {
        fromDateLabel.text = timeFormatter.string(from: fromDatePicker.date)
        toDateLabel.text = timeFormatter.string(from: toDatePicker.date)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NotificationsPreferencesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath),
           ["fromTimeCell", "toTimeCell"].contains(cell.reuseIdentifier) {
            
            if cell.reuseIdentifier == "fromTimeCell" {
                isToDatePickerHidden = true
                isFromDatePickerHidden = !isFromDatePickerHidden
            } else if cell.reuseIdentifier == "toTimeCell" {
                isFromDatePickerHidden = true
                isToDatePickerHidden = !isToDatePickerHidden
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(164)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            switch (cell.reuseIdentifier) {
            case "fromTimeCell":
                return isFromDatePickerHidden ? normalCellHeight : largeCellHeight
            case "toTimeCell":
                return isToDatePickerHidden ? normalCellHeight : largeCellHeight
            default:
                return normalCellHeight
            }
        }
        
        return normalCellHeight
    }
}
