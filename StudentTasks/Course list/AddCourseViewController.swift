//
//  AddCourseViewController.swift
//  StudentTasks
//
//  Created by mobileProg on 1/2/21.
//

import UIKit

class AddCourseTableViewController: UITableViewController {

    
    @IBOutlet weak var CourseImg: UIImageView!
    
    @IBOutlet weak var CourseCode: UITextField!
    
    @IBOutlet weak var CourseName: UITextField!
    
    @IBOutlet weak var CourseTeacher: UITextField!
    
    @IBOutlet var CourseType: UISegmentedControl!
    
    @IBOutlet weak var CourseAbbreviation: UITextField!
    
    @IBOutlet weak var CourseLocation: UITextField!
    
    @IBAction func AddBtnClicked(_ sender: Any) {
        
        var color = CodableColor.init(color: .blue)
        var Course1 = Course.init(color: color, name: CourseName.text!, code: CourseCode.text!, abberivation: CourseAbbreviation.text!, tags: CourseTag.allCases, lecturerName: CourseTeacher.text!)
        Course1.create()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
