//
//  MyQuestsViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/16/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class MyQuestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    // Table View
    @IBOutlet weak var tasksTableView: UITableView!
    
    // Buttons active and done
    @IBOutlet var activeAndDoneButtons: [UIButton]!
    
    // API urls
    let activeTasks = "http://dailyquests.club/JessyServer/v1/inprogress.php"
    let doneTasks = "http://dailyquests.club/JessyServer/v1/completed.php"
    let completeTask = "http://dailyquests.club/JessyServer/v1/taskcompleted.php"
    let updateExpAndCoins = ["http://dailyquests.club/JessyServer/v1/experience_update.php", "http://dailyquests.club/JessyServer/v1/coins_update.php"]
    
    // Variables
    var username: String?
    var userCoins: Int?
    var userExp: Int?
    var tasksInProgress: [Task] = []
    var tasksDone: [TaskDone] = []
    var buttonPressed: Int = 0
    var alert: UIAlertController!
    var okAction: UIAlertAction!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        retrieveActiveQuests()
        activeAndDoneButtons[0].backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
    
    // The number of rows will be determined by the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnedArray = 0
        
        switch buttonPressed
        {
        case 0:
            returnedArray = self.tasksInProgress.count
        case 1:
            returnedArray = self.tasksDone.count
        default:
            print("No return found")
        }
        
        return returnedArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Re-use an existing cell or creating a new one if needed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TasksTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        }
        
        
        switch buttonPressed
        {
        case 0:
            if tasksInProgress.count > 0
            {
                cell.title_label.text = self.tasksInProgress[indexPath.row].title
                cell.description_label.text = self.tasksInProgress[indexPath.row].description
                cell.dateCompletion_label.text = " "
                cell.coins_label.text = String(self.tasksInProgress[indexPath.row].coins)
                cell.exp_label.text = String(self.tasksInProgress[indexPath.row].experience)
                
                switch self.tasksInProgress[indexPath.row].difficulty
                {
                case 0:
                    cell.difficulty_imageView.image = #imageLiteral(resourceName: "easy")
                    cell.difficulty_label.text = "EASY"
                case 1:
                    cell.difficulty_imageView.image = #imageLiteral(resourceName: "medium")
                    cell.difficulty_label.text = "MED"
                case 2:
                    cell.difficulty_imageView.image = #imageLiteral(resourceName: "hard")
                    cell.difficulty_label.text = "HARD"
                default:
                    print("No image was found")
                }
            }
        case 1:
            if tasksDone.count > 0
            {
                cell.title_label.text = self.tasksDone[indexPath.row].title
                cell.description_label.text = self.tasksDone[indexPath.row].description
                cell.dateCompletion_label.text = self.tasksDone[indexPath.row].completion
                cell.coins_label.text = String(self.tasksDone[indexPath.row].coins)
                cell.exp_label.text = String(self.tasksDone[indexPath.row].experience)
                
                switch self.tasksDone[indexPath.row].difficulty
                {
                case 0:
                    cell.difficulty_imageView.image = #imageLiteral(resourceName: "easy")
                    cell.difficulty_label.text = "EASY"
                case 1:
                    cell.difficulty_imageView.image = #imageLiteral(resourceName: "medium")
                    cell.difficulty_label.text = "MED"
                case 2:
                    cell.difficulty_imageView.image = #imageLiteral(resourceName: "hard")
                    cell.difficulty_label.text = "HARD"
                default:
                    print("No image was found")
                }
            }
        default:
            print("No case found")
        }

        return cell
    }
    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func activeOrDone(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 0:
            buttonPressed = 0
            tasksTableView.reloadData()
            
            activeAndDoneButtons[0].backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5)
            activeAndDoneButtons[1].backgroundColor = nil
            
            
            
        case 1:
            buttonPressed = 1
            retrieveDoneQuests()
            tasksTableView.reloadData()
            
            activeAndDoneButtons[1].backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5)
            activeAndDoneButtons[0].backgroundColor = nil
        default:
            print("No tag found")
        }
    }
    
    func retrieveActiveQuests()
    {
        // Clearing array that holds the tasks in progress
        tasksInProgress.removeAll()
        
        // Setting the parameter to be sent to the database request
        let parameters: Parameters = ["username":username!]
        
        // Making a request
        Alamofire.request(activeTasks, method: .post, parameters: parameters).responseJSON
            { (response) in
                
                // Getting the json value from the server
                if let result = response.result.value
                {
                    let jsonData = result as! NSDictionary
                    
                    // Getting Data from response
                    let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                    
                    // Getting second-level data
                    // title, description, difficulty, coins, exp
                    for object in userData
                    {
                        guard let taskTitle = object["title"] as? String,
                            let taskDesc = object["description"] as? String,
                            let taskDifficulty = object["difficulty"] as? Int,
                            let taskCoins = object["coins"] as? Int,
                            let taskExp = object["experience"] as? Int,
                            let taskId = object["taskId"] as? Int
                            else { print("Hey this is the return"); return }
                        
                        // Add this task to the task array as Task type
                        self.tasksInProgress.append(Task(taskTitle: taskTitle, taskDescription: taskDesc, taskDifficulty: taskDifficulty, taskCoins: taskCoins, taskExp: taskExp, taskId: taskId))
                    }
                    
                    /* for task in self.tasksInProgress
                     {
                        print("Title: \(task.title) -- Description: \(task.description) -- Difficulty: \(task.difficulty) -- Coins: \(task.coins) -- Exp: \(task.experience) -- TaskId: \(task.questId)")
                     }
                     
                     print("Count array: \(self.tasksInProgress.count)")*/
                    
                    self.tasksTableView.reloadData()
                }
        }
    }
    
    func retrieveDoneQuests()
    {
        // Clearing array that holds the quests done
        tasksDone.removeAll()
        
        // Setting the parameter to be sent to the database request
        let parameters: Parameters = ["username":username!]
        
        // Making a request
        Alamofire.request(doneTasks, method: .post, parameters: parameters).responseJSON
            { (response) in
                
                // Getting the json value from the server
                if let result = response.result.value
                {
                    let jsonData = result as! NSDictionary
                    
                    // Getting Data from response
                    let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                    
                    // Getting second-level data
                    // title, description, difficulty, coins, exp
                    for object in userData
                    {
                        guard let taskTitle = object["title"] as? String,
                            let taskDesc = object["description"] as? String,
                            let taskDate = object["completeDate"] as? String,
                            let taskDifficulty = object["difficulty"] as? Int,
                            let taskCoins = object["coins"] as? Int,
                            let taskExp = object["experience"] as? Int
                            else { print("Hey this is the return"); return }
                        
                        // Add this task to the task array as Task type
                        self.tasksDone.append(TaskDone(taskTitle: taskTitle, taskDescription: taskDesc, taskCompletionDate: taskDate, taskDifficulty: taskDifficulty, taskCoins: taskCoins, taskExp: taskExp))
                    }
                    /*
                    for task in self.tasksDone
                    {
                        print("Title: \(task.title) -- Description: \(task.description) -- Date: \(task.completion) -- Difficulty: \(task.difficulty) -- Coins: \(task.coins) -- Exp: \(task.experience)")
                    }
                    
                    print("Count array: \(self.tasksDone.count)")*/
                    
                    self.tasksTableView.reloadData()
                }
        }
    }
    
    // This function will set a selected quest as completed in the database
    func completeSelectedTask(taskId: Int)
    {
        // Setting the parameter that will be sent to the database through a request
        let parameters: Parameters = ["taskId":taskId]
        
        // Making a request
        Alamofire.request(completeTask, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            print(response)
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                let jsonData = result as! NSDictionary
                
                // If there is no error, reloadData()
                if (!(jsonData.value(forKey: "error") as! Bool))
                {
                    self.retrieveActiveQuests()
                }
                else
                {
                    self.simpleAlert(title: "Oops!", message: "This quest does not exist")
                }
            }
        }
    }
    
    func updateCoinsAndExp(questCoin: Int, questExp: Int)
    {
        // Adding quest's coins and exp to the user's current coins and exp
        let updatedCoins = userCoins! + questCoin
        let updatedExp = userExp! + questExp
        
        // Setting up parameters for coins and exp update
        let coinsParameters: Parameters = ["username":username!, "coins":updatedCoins]
        let expParameters: Parameters = ["username":username!, "experience":updatedExp]
        let paraArray = [coinsParameters, expParameters]
        
        // Making a request
        for api in updateExpAndCoins
        {
            for parameters in paraArray
            {
                Alamofire.request(api, method: .post, parameters: parameters).responseJSON
                { (response) in
                    
                    print(response)
                    
                    // Getting the json value from the server
                    if let result = response.result.value
                    {
                        let jsonData = result as! NSDictionary
                        
                        // If there is no error, display a message about updating the exp and coins
                        if (!(jsonData.value(forKey: "error") as! Bool))
                        {
                            //self.simpleAlert(title: "Rewards", message: "Your coins and experience were updated!")
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    // This function will verify if the textField in the alert has been changed
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if alert.textFields?.first?.text != ""
        {
            //nickname = alert.textFields?.first?.text
            //playerInfo![2] = (alert.textFields?.first?.text)!
            //print("Not empty: \(self.nickname!)")
            //self.connectionStatusLabel.text = self.nickname!
            okAction.isEnabled = true
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if buttonPressed == 0
        {
            // Show an alert asking if the user would like to complete the current quest
            alert = UIAlertController(title: "Turn in quests", message: "Is this quest completed?", preferredStyle: UIAlertControllerStyle.alert)
            
            let yesButton = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
                let currentTaskId = self.tasksInProgress[indexPath.row].questId
                self.completeSelectedTask(taskId: currentTaskId)
                
                // Updating user's current coins and experience based on completed quest
                let currentTaskCoins = self.tasksInProgress[indexPath.row].coins
                let currentTaskExp = self.tasksInProgress[indexPath.row].experience
                self.updateCoinsAndExp(questCoin: currentTaskCoins, questExp: currentTaskExp)
            }
            let noButton = UIAlertAction(title: "No", style: .cancel) { (alertAction) in
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            present(alert, animated:true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "newQuestGo"
        {
            // Prepare the variable that will be sent forward
            let playerUsername = username
            
            // Passing data
            guard let destination = segue.destination as? NewTaskViewController else { return }
            destination.username = playerUsername
        }
        
    }

    func simpleAlert(title: String, message: String)
    {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (alertAction) in
        }
        
        alert.addAction(okButton)
        
        present(alert, animated:true, completion: nil)
    }
}
