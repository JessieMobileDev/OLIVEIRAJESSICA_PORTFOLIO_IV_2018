//
//  AchievementsViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/25/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class AchievementsViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var topMenuView: UIView!
    @IBOutlet var difficultyLabels: [UILabel]!
    
    // Variables
    var colorDefaults = UserDefaults.standard
    var username: String?
    let questsCountApis: [String] = ["http://dailyquests.club/JessyServer/v1/listhardtasks.php", "http://dailyquests.club/JessyServer/v1/listmedtasks.php", "http://dailyquests.club/JessyServer/v1/listeasytasks.php"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Change the color of the top view according to what is saved in the user defaults
        topMenuView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
        
        // Round labels and color background
        for label in difficultyLabels
        {
            label.clipsToBounds = true
            label.layer.cornerRadius = 20
        }

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Update count labels
        getQuestsCount()
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getQuestsCount()
    {
        // Create the parameters that will be sent
        let parameters: Parameters = ["username": username!]
        
        // Make the request
        var i = 0
        for api in questsCountApis
        {
            Alamofire.request(api, method: .post, parameters: parameters).responseJSON
            { (response) in
            
                // Getting the json value from the server
                if let result = response.result.value
                {
                    let jsonData = result as! NSDictionary
                    
                    // Getting Data from response
                    let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                    
                    if userData.count == 0
                    {
                        // Update the label to 0 quests
                        /*if i == 0
                        {
                            self.difficultyLabels[0].text = "0"
                        }
                        else if i == 1
                        {
                            self.difficultyLabels[1].text = "0"
                        }
                        else if i == 2
                        {
                            self.difficultyLabels[2].text = "0"
                        }*/
                        self.difficultyLabels[i].text = "0"
                        //self.difficultyArrayValues.append(0)
                        print("it's empty")
                        i += 1
                    }
                    else if userData.count > 0
                    {
                        // Update the label to specific quests amount
                        self.difficultyLabels[i].text = userData.count.description
                        //self.difficultyArrayValues.append(userData.count)
                        /*if i == 0
                        {
                            self.difficultyLabels[0].text = userData.count.description
                        }
                        else if i == 1
                        {
                            self.difficultyLabels[1].text = userData.count.description
                        }
                        else if i == 2
                        {
                            self.difficultyLabels[2].text = userData.count.description
                        }*/
                        i += 1
                        print("not empty")
                    }

                }
            }
        }
    }
}
