//
//  CompletedTaskTableViewCell.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 1/5/21.
//

import UIKit

class CompletedTaskTableViewCell: UITableViewCell {
    //refrencing Cell UI items
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var rightDetails: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
