//
//  TaskDone.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/18/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Foundation

class TaskDone
{
    // Stored properties
    var title: String
    var description: String
    var completion: String
    var difficulty: Int
    var coins: Int
    var experience: Int
    
    // Initializer
    init(taskTitle: String, taskDescription: String, taskCompletionDate: String, taskDifficulty: Int, taskCoins: Int, taskExp: Int)
    {
        self.title = taskTitle
        self.description = taskDescription
        self.completion = taskCompletionDate
        self.difficulty = taskDifficulty
        self.coins = taskCoins
        self.experience = taskExp
    }
}
