//
//  Task.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/17/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Foundation

class Task
{
    // Stored properties
    var title: String
    var description: String
    var difficulty: Int
    var coins: Int
    var experience: Int
    
    // Initializer
    init(taskTitle: String, taskDescription: String, taskDifficulty: Int, taskCoins: Int, taskExp: Int)
    {
        self.title = taskTitle
        self.description = taskDescription
        self.difficulty = taskDifficulty
        self.coins = taskCoins
        self.experience = taskExp
    }
}
