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
    
    // Grading section
    var gradingSettings: GradingSettings = GradingSettings.instance
    @IBOutlet weak var gpaModelLabel: UILabel!
    //
    
    var appearanceSettings: AppearanceSettings  = AppearanceSettings.load()
    @IBOutlet weak var themeLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadNotificationsSettings()
        updateGradingSection()
        updateAppearanceSection()
        
        if let version = Constants.appVersion {
            versionLabel.text = version
        }
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
            } else if segue.identifier ==  "themeSegue" {
                pickerTableView.title = "Theme"
                pickerTableView.multiSelect = false
                
                for theme in AppearanceTheme.allCases {
                    var pickerItem = PickerItem(identifier: theme.rawValue, label: theme.description, checked: false)
                    if appearanceSettings.theme == theme {
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
            } else if pickerView.identifier == "themeSegue" {
                handleThemePicker(items: pickerView.items)
            }
        }
    }
}

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath),
           cell.reuseIdentifier == "languageCell" {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}

extension SettingsTableViewController {
    private func loadNotificationsSettings() {
        self.notificationSwitch.isOn = NotificationSettings.instance.notificationsEnabled

        NotificationCenter.default.addObserver(self, selector: #selector(self.notifcationChanged), name: Constants.notifcationSettings["enabledChanged"]!, object: nil)
    }
    
    @objc private func notifcationChanged(notification: NSNotification) {
        guard let notificationSettings = notification.object as? NotificationSettings else { return }
        
        self.notificationSwitch.isOn = notificationSettings.notificationsEnabled
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
        if sender.isOn == true && NotificationSettings.instance.notificationsGranted == false {
            sender.isOn = false
            notificationsSettingsPrompt()
        } else {
            var notificationSettings = NotificationSettings.instance
            notificationSettings.switchEnabled(on: sender.isOn)
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

extension SettingsTableViewController {
    func updateAppearanceSection() {
        themeLabel.text = appearanceSettings.theme.description
    }

    func handleThemePicker(items: [PickerItem]) {
        guard let choosedItem = items.first(where: { $0.checked }),
              let model = AppearanceTheme(rawValue: choosedItem.identifier) else { return }
        
        appearanceSettings.theme = model
        appearanceSettings.update()
        
        updateAppearanceSection()
    }
}
