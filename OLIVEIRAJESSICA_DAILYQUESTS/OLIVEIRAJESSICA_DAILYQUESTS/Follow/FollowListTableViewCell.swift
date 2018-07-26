//
//  FollowListTableViewCell.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/24/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import UIKit

class FollowListTableViewCell: UITableViewCell
{
    // Labels that will be updated when the screen is opened
    @IBOutlet weak var followAvatar: UIImageView!
    @IBOutlet weak var followUsername: UILabel!
    @IBOutlet weak var followLevel: UILabel!
    @IBOutlet weak var followCoins: UILabel!
    
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
