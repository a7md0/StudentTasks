//
//  CourseFormTableViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/5/21.
//

import UIKit

class CourseFormTableViewController: UITableViewController {

    @IBOutlet weak var courseNameTextfield: UITextField!
    
    @IBOutlet weak var colorSlider: UISlider!
    
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var courseAbberivationLabel: UILabel!
    @IBOutlet weak var courseLecturerLabel: UILabel!
    
    var editMode = false
    var unwindSegue = "unwindToCoursesFromAdd"
    var course: Course?
    
    var courseTags: [CourseTag] = [.lecture]
    var courseColor: CodableColor?
    
    let colors = [4293212469, 4292352864, 4287505578, 4284364209, 4281944491, 4280191205, 4278234305, 4278225275, 4282622023, 4290824755, 4294947584, 4294201630, 4285353025, 4283723386]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let course = self.course {
            self.editMode = true
            
            navigationItem.title = "Edit course"
            self.courseTags = course.tags
            self.courseColor = course.color
            
            if let color = course.color {
                self.colorFrom(color: color)
            }
            
            updateView()
        }  else {
            self.setRandomColor()
        }
                
        setupColorSlider()
    }
    
    func updateView() {
        guard let course = self.course else { return }
        
        courseNameTextfield.text = course.name
        
        courseCodeLabel.text = course.code ?? "Unset"
        courseAbberivationLabel.text = course.abberivation ?? "Unset"
        courseLecturerLabel.text = course.lecturerName ?? "Unset"
    }
    
    
    
    func handlePickerTagsSelection(items: [PickerItem]) {
        self.courseTags = []
        
        items.filter { $0.checked }.forEach { (item) in
            if let courseTag = CourseTag(rawValue: item.identifier) {
                self.courseTags.append(courseTag)
            }
        }
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}

extension CourseFormTableViewController {
    @IBAction func colorSliderChanged(_ sender: UISlider) {
        colorPicked()
    }
    
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
                    if let course = self.course, course.tags.contains(courseTag) {
                        pickerItem.checked = true
                    }
                    
                    pickerTableView.items.append(pickerItem)
                }
            }
        }
    }
    
    @IBAction func unwindToCourseForm(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if unwindSegue.identifier == "unwindCourseForm",
           let pickerTableView = unwindSegue.source as? PickerTableViewController {
            handlePickerTagsSelection(items: pickerTableView.items)
        }
    }
}
