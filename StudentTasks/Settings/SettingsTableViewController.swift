//
//  SettingsTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/27/20.
//

import UIKit

enum GpaModel: String, CustomStringConvertible, Codable, CaseIterable {
    var description: String {
        switch self {
        case .fourPlus:
            return "4.0 Scale (+)"
        case .fourPlusMinus:
            return "4.0 Scale (+/-)"
        case .hundredPercentage:
            return "Percentage scale (%)"
        }
    }
    
    case fourPlus = "4+", fourPlusMinus = "4+-", hundredPercentage = "100%"
}

class SettingsTableViewController: UITableViewController {
    private let defaults = UserDefaults.standard
    
    // Notification section
    @IBOutlet var notificationSwitch: UISwitch!
    //
    
    // Grading section
    var gpaModel: GpaModel = .fourPlusMinus
    @IBOutlet weak var gpaModelLabel: UILabel!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadNotificationsSettings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    func handleGpaModelPicker(items: [PickerItem]) {
        guard let choosedItem = items.first(where: { $0.checked }),
              let model = GpaModel(rawValue: choosedItem.identifier) else { return }
        
        gpaModel = model
        gpaModelLabel.text = gpaModel.description
        // TODO: Save choosed gpa model
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
                    /*if notificationSettings.preferredTypes.contains(model) {
                        pickerItem.checked = true
                    }*/
                    
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
        let notificationSettings: NotificationSettings = NotificationSettings.load()
        notificationSwitch.isOn = notificationSettings.notificationsEnabled

        NotificationCenter.default.addObserver(self, selector: #selector(self.notifcationChanged), name: Constants.notifcationSettings["enabledChanged"]!, object: nil)
    }
    
    @objc private func notifcationChanged(notification: NSNotification) {
        guard let notificationSettings = notification.object as? NotificationSettings else { return }
        
        notificationSwitch.isOn = notificationSettings.notificationsEnabled
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        defaults.setValue(sender.isOn, forKey: "notificationEnabled")
    }
}
