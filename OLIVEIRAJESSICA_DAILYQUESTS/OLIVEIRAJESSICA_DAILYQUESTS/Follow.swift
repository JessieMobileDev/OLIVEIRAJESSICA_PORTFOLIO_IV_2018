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
    var experience: Int
    var coins: Int
    
    // Initializer
    init(followUsername: String, followExp: Int, followCoins: Int)
    {
        self.username = followUsername
        self.experience = followExp
        self.coins = followCoins
    }
}
