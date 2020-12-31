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
    var notificationSettings: NotificationSettings = NotificationSettings.load()
    @IBOutlet var notificationSwitch: UISwitch!
    //
    
    // Grading section
    var gradingSettings: GradingSettings = GradingSettings.load()
    @IBOutlet weak var gpaModelLabel: UILabel!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadNotificationsSettings()
        updateGradingSection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Navigation
extension SettingsTableViewController {
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        if let pickerTableView = segue.destination as? PickerTableViewController {
            pickerTableView.identifier = segue.identifier
            pickerTableView.unwindSegueIdentifier = "unwindSettings"
            
            if segue.identifier == "gpaModelSegue" {
                pickerTableView.title = "GPA Model"
                pickerTableView.multiSelect = false
                
                for model in GpaModel.allCases {
                    var pickerItem = PickerItem(identifier: model.rawValue, label: model.description, checked: false)
                    if gradingSettings.gpaModel == model {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            }
        }
    }
    
    @IBAction func unwindToSettingsTab(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if unwindSegue.identifier == "unwindSettings",
           let pickerView = sourceViewController as? PickerTableViewController {
            if pickerView.identifier == "gpaModelSegue" {
                handleGpaModelPicker(items: pickerView.items)
            }
        }
    }
}

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsTableViewController {
    private func loadNotificationsSettings() {
        self.notificationSwitch.isOn = notificationSettings.notificationsEnabled

        NotificationCenter.default.addObserver(self, selector: #selector(self.notifcationChanged), name: Constants.notifcationSettings["enabledChanged"]!, object: nil)
    }
    
    @objc private func notifcationChanged(notification: NSNotification) {
        guard let notificationSettings = notification.object as? NotificationSettings else { return }
        
        self.notificationSwitch.isOn = notificationSettings.notificationsEnabled
        self.notificationSettings = notificationSettings
    }
    
    func openAppSettings() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
    
    func notificationsSettingsPrompt() {
        let confirmAlert = UIAlertController(title: "Notifications disabled", message: "Notifications are disabled for this app, would you like to enable them?", preferredStyle: .alert)

        confirmAlert.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { (action: UIAlertAction!) in
            self.openAppSettings()
        }))

        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn == true && notificationSettings.notificationsGranted == false {
            sender.isOn = false
            notificationsSettingsPrompt()
        } else {
            notificationSettings.notificationsEnabled = sender.isOn
            notificationSettings.update()
        }
    }
}

extension SettingsTableViewController {
    func updateGradingSection() {
        gpaModelLabel.text = gradingSettings.gpaModel.description
    }

    func handleGpaModelPicker(items: [PickerItem]) {
        guard let choosedItem = items.first(where: { $0.checked }),
              let model = GpaModel(rawValue: choosedItem.identifier) else { return }
        
        gradingSettings.gpaModel = model
        gradingSettings.update()
        
        updateGradingSection()
    }
}
