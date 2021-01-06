//
//  CourseFormTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/5/21.
//

import UIKit

class CourseFormTableViewController: UITableViewController {
    // refrencing IBOutlets
    @IBOutlet weak var courseNameTextfield: UITextField!
    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var courseAbberivationLabel: UILabel!
    @IBOutlet weak var courseLecturerLabel: UILabel!
    //Declaring Variables
    var editMode = false
    var unwindSegue = "unwindToCoursesFromAdd"
    var course: Course?
    var courseTags: [CourseTag] = [.lecture]
    var courseColor: CodableColor?
    var courseCode: String?
    var courseAbberivation: String?
    var courseLecturer: String?
    
    // color array used for Color picker
    let colors = [4293212469, 4292352864, 4287505578, 4284364209, 4281944491, 4280191205, 4278234305, 4278225275, 4282622023, 4290824755, 4294947584, 4294201630, 4285353025, 4283723386]

    override func viewDidLoad() {
        super.viewDidLoad()
            // isnserting values (only for editing)
        if let course = self.course {
            self.editMode = true
            navigationItem.title = course.name
            self.courseTags = course.tags
            self.courseColor = course.color
            self.courseCode = course.code
            self.courseAbberivation = course.abberivation
            self.courseLecturer = course.lecturerName
            
            if let color = course.color {
                self.colorFrom(color: color)
            }
            
            updateView()
        }  else {
            self.setRandomColor()
        }
                
        setupColorSlider()
    }
    
    // Saving all the ourputs from textfield, Alert textboxex to course object
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let courseNameText = courseNameTextfield.text,
              let courseColor = self.courseColor else { return }
        if self.editMode {
            self.course?.name = courseNameText
            self.course?.color = courseColor
            self.course?.code = self.courseCode
            self.course?.abberivation = self.courseAbberivation
            self.course?.tags = courseTags
            self.course?.lecturerName = self.courseLecturer
            
            self.course?.save()
        } else {
            var course = Course(color: courseColor, name: courseNameText, code: nil, abberivation: nil, tags: courseTags, lecturerName: nil)
            course.create()
        }
        
        performSegue(withIdentifier: self.unwindSegue, sender: self)
    }
    
    //updating the view
    func updateView() {
        guard let course = self.course else { return }
        
        courseNameTextfield.text = course.name
        courseCodeLabel.text = self.courseCode ?? NSLocalizedString("Unset", comment: "Unset")
        courseAbberivationLabel.text = self.courseAbberivation ?? NSLocalizedString("Unset", comment: "Unset")
        courseLecturerLabel.text = self.courseLecturer ?? NSLocalizedString("Unset", comment: "Unset")
    }
    
    
    // Assigning Course tags
    func handlePickerTagsSelection(items: [PickerItem]) {
        self.courseTags = []
        
        items.filter { $0.checked }.forEach { (item) in
            if let courseTag = CourseTag(rawValue: item.identifier) {
                self.courseTags.append(courseTag)
            }
        }
    }
    
    // MARK: - Table view data source
    // Alerting the user with the right message when clicking on rows For ex, corse code , Abbervation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier {
            var alert: UIAlertController?
            // checking the identifier for each sepecific row
            switch identifier {
            case "courseCodeCell":
                alert = PromptHelper.promptText(title: NSLocalizedString("Course code", comment: "Course code"), message: NSLocalizedString("Enter code", comment: ""), placeholder: NSLocalizedString("IT6000", comment: ""), value: self.courseCode) { (text) in
                    
                    self.courseCode = text
                    
                    self.updateView()
                }
            case "courseAbberivationCell":
                alert = PromptHelper.promptText(title: NSLocalizedString("Abberivation", comment: ""), message: NSLocalizedString("Enter short abberivation", comment: ""), placeholder: NSLocalizedString("MP", comment: ""), value: self.courseAbberivation) { (text) in
                    
                    self.courseAbberivation = text
                    
                    self.updateView()
                }
            case "courseLecturerCell":
                alert = PromptHelper.promptText(title: NSLocalizedString("Lecturer name", comment: ""), message: NSLocalizedString("Enter lecturer name", comment: ""), placeholder: NSLocalizedString("Name", comment: ""), value: self.courseLecturer) { (text) in
                    
                    self.courseLecturer = text
                    
                    self.updateView()
                }
            default:
                return
            }
            // presenting the alert
            if let alert = alert {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension CourseFormTableViewController {
    @IBAction func colorSliderChanged(_ sender: UISlider) {
        colorPicked()
    }
    // setup the action for the color picker
    func setupColorSlider() {
        // https://stackoverflow.com/a/34619780/1738413
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderTapped))
        self.colorSlider.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /*
     https://stackoverflow.com/a/34619780/1738413
     */
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        
        let positionOfSlider: CGPoint = colorSlider.frame.origin
        let widthOfSlider: CGFloat = colorSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(colorSlider.maximumValue) / widthOfSlider)
        
        colorSlider.setValue(Float(newValue), animated: true)
        colorPicked()
    }
    
    func colorPicked() {
        let idx = Int(colorSlider.value)
        let uiColor = UIColor(rgb: self.colors[idx])
        
        courseColor = CodableColor(color: uiColor)
    }
    
    func colorFrom(color: CodableColor) {
        if let rgb = color.color.rgb(),
           let colorIdx = self.colors.firstIndex(where: { $0 == rgb }) {
            
            colorSlider.value = Float(colorIdx)
            colorPicked()
        }
    }
    // Setting random number from the array when loading the view
    func setRandomColor() {
        if let rndValue = stride(from: 0, through: 13.5, by: 0.5).shuffled().last {
            colorSlider.value = Float(rndValue)
            colorPicked()
        }
    }
}

// MARK: - Navigation
extension CourseFormTableViewController {
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let pickerTableView = segue.destination as? PickerTableViewController {
            
            pickerTableView.identifier = segue.identifier
            pickerTableView.multiSelect = true
            pickerTableView.unwindSegueIdentifier = "unwindCourseForm"
            
            if segue.identifier == "pickCourseTagsSegue" {
                pickerTableView.title = "Course tags"
                
                for courseTag in CourseTag.allCases {
                    var pickerItem = PickerItem(identifier: courseTag.rawValue, label: courseTag.rawValue, checked: false)
                    if courseTags.contains(courseTag) {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            }
        }
    }
    
    @IBAction func unwindToCourseForm(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if unwindSegue.identifier == "unwindCourseForm",
           let pickerTableView = unwindSegue.source as? PickerTableViewController {
            handlePickerTagsSelection(items: pickerTableView.items)
        }
    }
}
