//
//  SearchFollowTableViewCell.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/26/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import UIKit

class SearchFollowTableViewCell: UITableViewCell
{
    // Outlets
    @IBOutlet weak var avatar_image: UIImageView!
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var level_label: UILabel!
    @IBOutlet weak var coins_label: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
