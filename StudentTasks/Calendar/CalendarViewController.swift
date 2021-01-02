//
//  CalendarViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/2/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupFSCalendar()
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

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func setupFSCalendar() {
        calendarView.dataSource = self
        calendarView.delegate = self
    }
}
