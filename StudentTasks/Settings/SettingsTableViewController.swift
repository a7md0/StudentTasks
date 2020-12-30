//
//  SettingsTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/27/20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    private let defaults = UserDefaults.standard
    
    // Notification section
    @IBOutlet var notificationSwitch: UISwitch!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadNotificationsSettings()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToSettingsTab(_ unwindSegue: UIStoryboardSegue) {
        // let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}

extension SettingsTableViewController {
    private func loadNotificationsSettings() {
        notificationSwitch.isOn = defaults.bool(forKey: "notificationEnabled")
        /*if let data = UserDefaults.standard.data(forKey: "notificationTaskTypes"),
           let types = try? JSONDecoder().decode(Array<TaskType>.self, from: data) {
            self.notificationTaskTypes = types
        }*/
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        defaults.setValue(sender.isOn, forKey: "notificationEnabled")
    }
}
