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
    
    // Variables
    var username: String?
    var tasksInProgress: [Task] = []
    var buttonPressed: Int = 0
    var alert: UIAlertController!
    var okAction: UIAlertAction!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Clearing dictionary that holds the tasks in progress
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
                        let taskExp = object["experience"] as? Int
                        else { print("Hey this is the return"); return }
                    
                    // Add this task to the task array as Task type
                    self.tasksInProgress.append(Task(taskTitle: taskTitle, taskDescription: taskDesc, taskDifficulty: taskDifficulty, taskCoins: taskCoins, taskExp: taskExp))
                }
                
                for task in self.tasksInProgress
                {
                    print("Title: \(task.title) -- Description: \(task.description) -- Difficulty: \(task.difficulty) -- Coins: \(task.coins) -- Exp: \(task.experience)")
                }
                
                print("Count array: \(self.tasksInProgress.count)")
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
    
    // The number of rows will be determined by the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
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
            cell.title_label.text = "Testing ACTIVE button"
            cell.description_label.text = "I am testing to see if this works"
            cell.dateCompletion_label.text = "Today and now"
            cell.coins_label.text = "678"
            cell.exp_label.text = "150"
        case 1:
            cell.title_label.text = "Testing DONE button"
            cell.description_label.text = "I am testing to see if this works"
            cell.dateCompletion_label.text = "Today and now"
            cell.coins_label.text = "678"
            cell.exp_label.text = "150"
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
        case 1:
            buttonPressed = 1
            tasksTableView.reloadData()
        default:
            print("No tag found")
        }
    }
    
    @IBAction func addTask(_ sender: UIButton)
    {
        // Create an alert window to capture info about the task
        alert = UIAlertController(title: "New Quest", message: "What's your nickname?", preferredStyle: UIAlertControllerStyle.alert)
        
        okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in }
        
        okAction.isEnabled = false // Initially false
        
        alert.addTextField { (textField) in
            textField.placeholder = "Jessie"
            textField.addTarget(self, action: #selector(self.textField(_:shouldChangeCharactersIn:replacementString:)), for: UIControlEvents.editingChanged) }
        
        alert.addAction(okAction)
        
        
        present(alert, animated:true, completion: nil)
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

}
