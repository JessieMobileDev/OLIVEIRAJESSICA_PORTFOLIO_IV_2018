//
//  FollowListViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/24/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class FollowListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    // Variables
    var username: String?
    var getPeopleNameListIFollow: String = "http://dailyquests.club/JessyServer/v1/getfollowlist.php"
    var getPeopleFullInfo = "http://dailyquests.club/JessyServer/v1/getfollowing.php"
    var unfollowApi = "http://dailyquests.club/JessyServer/v1/unfollow.php"
    var alert: UIAlertController!
    var okAction: UIAlertAction!
    var colorDefaults = UserDefaults.standard
    var allFollowedUsers: [Follow] = []
    var allFollowUsernames: [String] = []
    
    // Outlets
    @IBOutlet weak var followTableView: UITableView!
    @IBOutlet weak var topMenuBarView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Change the views color according to what is saved in the user defaults
        topMenuBarView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
    }

    override func viewWillAppear(_ animated: Bool)
    {
        // Clear the arrays before using
        allFollowedUsers.removeAll()
        allFollowUsernames.removeAll()
        
        // Runs the return follows username
        returnAllMyFollowsUsernames()
        
        DispatchQueue.main.async
        {
            self.followTableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allFollowedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Re-use an existing cell or creating a new one if needed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as? FollowListTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath)
        }
        
        cell.followAvatar.image = UIImage(named: "A\(allFollowedUsers[indexPath.row].avatar)")
        cell.followUsername.text = allFollowedUsers[indexPath.row].username
        cell.followCoins.text = allFollowedUsers[indexPath.row].coins.description
        
        // Checks experience
        let level = levelsBreakDown(userExpCount: allFollowedUsers[indexPath.row].experience).levelCount
        let nextExp = levelsBreakDown(userExpCount: allFollowedUsers[indexPath.row].experience).nextLvlPerc
        cell.followLevel.text = "Level: \(level) [ \(nextExp)% ]"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Show an alert asking if the user wants to unfollow the selected person
        let alert = UIAlertController(title: "Unfollow?", message: "Would you like to unfollow \(allFollowedUsers[indexPath.row].username)?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            // Do the follow api calls
            self.unfollowSomeone(selectedUserName: self.allFollowedUsers[indexPath.row].username, removeIndex: indexPath.row)
            
            self.followTableView.reloadData()
            
        }
        let noButton = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        
        present(alert, animated:true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func followSomebody(_ sender: UIButton)
    {
        // TODO: Do api requests
    }
    
    func returnAllMyFollowsUsernames()
    {
        // Set up parameters to be sent through the request
        let parameters: Parameters = ["follower":username!]
        
        // Make the request
        Alamofire.request(getPeopleNameListIFollow, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                let jsonData = result as! NSDictionary
                
                // Getting Data from response
                let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                
                // Getting second-level data
                // Each user: username, experience, coins, currentAvatar
                for object in userData
                {
                    guard let userName = object["following"] as? String
                        else { return }
                    
                    self.allFollowUsernames.append(userName)
                }
                
                // Clears array before saving
                self.allFollowedUsers.removeAll()
                
                // Run the api that gets the info on the people that the username is being passed
                for i in self.allFollowUsernames
                {
                    self.returnAllFollowsInfo(followingPerson: i)
                }
                
                
            }
        }
    }
    
    func returnAllFollowsInfo(followingPerson: String)
    {
        // Set up the parameter that will be sent through the request
        let parameters: Parameters = ["following":followingPerson]
        
        // Make the request
        Alamofire.request(getPeopleFullInfo, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            // Getting the jason value from the server
            if let result = response.result.value
            {
                let jsonData = result as! NSDictionary
                
                // Getting Data from response
                let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                
                // Getting second-level data
                // Each user: username, experience, coins, currentAvatar
                for object in userData
                {
                    guard let username = object["username"] as? String,
                        let userAvatar = object["currentAvatar"] as? String,
                        let userExp = object["experience"] as? Int,
                        let userCoins = object["coins"] as? Int
                        else { print("Something from followed users is null"); return }
                    
                    // Save each followed user to the array
                    self.allFollowedUsers.append(Follow(followUsername: username, followAvatar: userAvatar, followExp: userExp, followCoins: userCoins))
                }
                
                self.followTableView.reloadData()
            }
        }
        
    }
    
    func unfollowSomeone(selectedUserName: String, removeIndex: Int)
    {
        // Set up the parameter that will be sent with the request
        let parameters: Parameters = ["follower":username!, "following":selectedUserName]
        
        // Make a request
        Alamofire.request(unfollowApi, method: .post, parameters: parameters).responseJSON
        { (response) in
        
            // Removes the specific user from both arrays
            self.allFollowedUsers.remove(at: removeIndex)
            self.allFollowUsernames.remove(at: removeIndex)
            
            self.followTableView.reloadData()
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "allUsersGo"
        {
            guard let destination = segue.destination as? SearchFollowViewController else { return }
            destination.username = username!
        }
    }
    
    func levelsBreakDown(userExpCount: Int) -> (levelCount: Int, nextLvlPerc: String)
    {
        let exponent: Double = 1.5
        let baseExp: Int = 1000
        var levelCount: Int = 1
        var currentMaxPerLevel: Double = 0.0
        var remainingExp: Double = 0.0
        var nextLevelMaxExp: Double = 0.0
        
        let baseLvl: Int = 1
        var counter: Int = 0
        var hasFoundMatchingLevel: Bool = false
        
        // While user experience is not higher or equal to the formula outcome, keep adding 1 to the counter until it finds a match
        while hasFoundMatchingLevel == false
        {
            // Base experience per level formula
            // Counter will change the outcome depending on the while loop below
            currentMaxPerLevel = (Double(baseExp) * (Double(baseLvl + counter) * exponent))
            
            if Double(userExpCount) > currentMaxPerLevel
            {
                counter += 1
            }
            else if Double(userExpCount) == currentMaxPerLevel
            {
                counter += 1
                
                // Subtract the user's experience from the max experience from the matching level
                remainingExp = currentMaxPerLevel - Double(userExpCount)
                levelCount = counter
                
                // Checks the next level's max experience
                nextLevelMaxExp = Double(baseExp) * exponent
                
                // It found a matching level
                hasFoundMatchingLevel = true
            }
            else
            {
                // Subtract the user's experience from the max experience from the matching level
                remainingExp = currentMaxPerLevel - Double(userExpCount)
                levelCount = counter
                
                nextLevelMaxExp = Double(baseExp) * exponent
                
                
                // It found a matching level
                hasFoundMatchingLevel = true
            }
        }
        
        // Check experience
        let nextLevelPercentage = (100 - (remainingExp * 100.0)/nextLevelMaxExp)
        let nextPerc = String(format: "%.2f", nextLevelPercentage as CVarArg)
        
        return (levelCount, nextPerc)
        
    }
}
