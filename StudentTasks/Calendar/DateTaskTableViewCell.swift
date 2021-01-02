//
//  DateTaskTableViewCell.swift
//  StudentTasks
//
//  Created by Sayed Ali on 1/2/21.
//

import UIKit

class DateTaskTableViewCell: UITableViewCell {
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    
    func taskDetails(task: Task){
        //courseImage.image = task.course.
        taskName.text = task.name
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }

}
