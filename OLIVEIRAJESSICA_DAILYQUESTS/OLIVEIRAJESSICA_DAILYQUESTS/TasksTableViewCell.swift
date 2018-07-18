//
//  TasksTableViewCell.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/16/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell
{
    // Labels that will be updated when screen is opened
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var dateCompletion_label: UILabel!
    @IBOutlet weak var coins_label: UILabel!
    @IBOutlet weak var exp_label: UILabel!
    @IBOutlet weak var difficulty_imageView: UIImageView!
    @IBOutlet weak var difficulty_label: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
