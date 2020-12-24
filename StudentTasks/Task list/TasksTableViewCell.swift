//
//  TasksTableViewCell.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/16/20.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //courseImage.backgroundColor = .systemPink // tmp
    }

}
