//
//  NewTaskViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/17/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class NewTaskViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    // Variables
    var saveQuest = "http://dailyquests.club/JessyServer/v1/createtask.php"
    var alert: UIAlertController!
    var okAction: UIAlertAction!
    var username: String?
    var tempCoins = 0
    var tempExp = 0
    var tempDifficulty = -1
    var colorDefaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Change the color of the views according to the saved color in user defaults
        topBarView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
        saveBtn.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingDifficulty(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 0: // Easy
            tempCoins = 50
            tempExp = 100
            tempDifficulty = 0
        case 1: // Medium
            tempCoins = 100
            tempExp = 180
            tempDifficulty = 1
        case 2: // Hard
            tempCoins = 150
            tempExp = 260
            tempDifficulty = 2
        default:
            print("No case found")
        }
    }
    
    
    @IBAction func saveQuest(_ sender: UIButton)
    {
        if taskTitle.text == "" || taskDescription.text == "" || tempDifficulty == -1
        {
            simpleAlert(title: "Oops!", message: "Don't forget to add anything!")
        }
        else
        {
            // Paramenter that will be sent to the API call
            let parameters: Parameters = ["username": username!, "title":taskTitle.text!, "difficulty":tempDifficulty,  "description":taskDescription.text!, "coins": tempCoins, "experience":tempExp]
            
            print("Username: \(username!) -- Title: \(taskTitle.text!) -- Description: \(taskDescription.text!) -- Difficulty: \(tempDifficulty) -- Coins: \(tempCoins) -- Exp: \(tempExp)")
            
            // Making a request
            Alamofire.request(saveQuest, method: .post, parameters: parameters).responseJSON
            { (response) in
                
                // Getting the json value from the server
                if let result = response.result.value
                {
                    // Coverting it as Int
                    let taskNumber = result as? Int
                    
                    print("Task Number: \(taskNumber!)")
                    
                    // Perform segue if save was successful
                    if taskNumber != nil
                    {
                        // After saving, clear text fields
                        self.taskTitle.text = ""
                        self.taskDescription.text = ""
                        self.tempDifficulty = -1
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
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
