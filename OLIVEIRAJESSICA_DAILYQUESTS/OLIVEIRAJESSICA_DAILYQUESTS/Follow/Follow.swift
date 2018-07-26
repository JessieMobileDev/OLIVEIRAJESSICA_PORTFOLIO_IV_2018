//
//  Follow.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/24/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Foundation

class Follow
{
    // Stored properties
    var username: String
    var avatar: String
    var experience: Int
    var coins: Int
    
    // Initializer
    init(followUsername: String, followAvatar: String, followExp: Int, followCoins: Int)
    {
        self.username = followUsername
        self.avatar = followAvatar
        self.experience = followExp
        self.coins = followCoins
    }
}
