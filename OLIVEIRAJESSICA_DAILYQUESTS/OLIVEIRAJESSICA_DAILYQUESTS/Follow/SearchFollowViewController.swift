//
//  SearchFollowViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/26/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class SearchFollowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate
{
    // Outlets
    @IBOutlet weak var topMenuBarView: UIView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    // Variables
    let searchFollowApi = "http://dailyquests.club/JessyServer/v1/listusers.php"
    let followUserApi = "http://dailyquests.club/JessyServer/v1/follow.php"
    var allUsers: [Follow] = []
    let colorDefaults = UserDefaults.standard
    var isSearching = false
    var filteredData: [Follow] = []
    var username: String?
    var alert: UIAlertController!
    var okAction: UIAlertAction!
    


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Assign search return key type
        userSearchBar.returnKeyType = UIReturnKeyType.done
        
        // Change the views colors according to the user's preferred color
        topMenuBarView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
        
        // Search for all users in the database
        listAllUsers()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let temp = [filteredData, allUsers]
        var tempArray = 0
        
        if isSearching
        {
            tempArray = 0
        }
        else
        {
            tempArray = 1
        }
        
        //return allUsers.count
        return temp[tempArray].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Re-use an existing cell or creating a new one if needed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell", for: indexPath) as? SearchFollowTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "searchUserCell", for: indexPath)
        }
        
        if isSearching
        {
            // Apply the saved users to the outlets
            cell.avatar_image.image = UIImage(named: "A\(self.filteredData[indexPath.row].avatar)")
            cell.username_label.text = self.filteredData[indexPath.row].username
            cell.coins_label.text = self.filteredData[indexPath.row].coins.description
            
            // Checks experience
            let level = levelsBreakDown(userExpCount: self.filteredData[indexPath.row].experience).levelCount
            let nextExp = levelsBreakDown(userExpCount: self.filteredData[indexPath.row].experience).nextLvlPerc
            cell.level_label.text = "Level: \(level) [ \(nextExp)% ]"
        }
        else
        {
            // Apply the saved users to the outlets
            cell.avatar_image.image = UIImage(named: "A\(self.allUsers[indexPath.row].avatar)")
            cell.username_label.text = self.allUsers[indexPath.row].username
            cell.coins_label.text = self.allUsers[indexPath.row].coins.description
            
            // Checks experience
            let level = levelsBreakDown(userExpCount: self.allUsers[indexPath.row].experience).levelCount
            let nextExp = levelsBreakDown(userExpCount: self.allUsers[indexPath.row].experience).nextLvlPerc
            cell.level_label.text = "Level: \(level) [ \(nextExp)% ]"
        }

        return cell
    }
    
    func tableView(_ collectionView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isSearching
        {
            let selectedUser = filteredData[indexPath.row]
            
            // Show an alert asking if the user wants to follow the selected user
            let alert = UIAlertController(title: "Follow?", message: "Would you like to follow \(selectedUser.username)?", preferredStyle: UIAlertControllerStyle.alert)
            
            let yesButton = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
                
                // Do the follow api calls
                // The api won't allow user to add the same person again
                self.followSomeone(following: selectedUser.username)
                
            }
            let noButton = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            present(alert, animated:true, completion: nil)
            
        }
        else
        {
            let selectedUser = allUsers[indexPath.row]
            
            // Show an alert asking if the user wants to follow the selected user
            let alert = UIAlertController(title: "Follow?", message: "Would you like to follow \(selectedUser.username)?", preferredStyle: UIAlertControllerStyle.alert)
            
            let yesButton = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
                
                // Do the follow api calls
                // The api won't allow user to add the same person again
                self.followSomeone(following: selectedUser.username)
                
            }
            let noButton = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            present(alert, animated:true, completion: nil)
        } 
    }
    
    func followSomeone(following: String)
    {
        // Set the parameters to be sent with the request
        let parameters: Parameters = ["follower":username!, "following":following]
        
        // Make the request
        Alamofire.request(followUserApi, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let data = result as! NSDictionary
                
                let returnMessage = data.value(forKey: "message") as? String
                
                if returnMessage == "Successfully Following"
                {
                    self.dismiss(animated: true, completion: nil)
                }
                else if returnMessage == "Cannot Follow"
                {
                    self.simpleAlert(title: "Oops!", message: "Already following")
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if userSearchBar.text == nil || userSearchBar.text == ""
        {
            isSearching = false
            
            view.endEditing(true)
            
            searchTableView.reloadData()
        }
        else
        {
            isSearching = true
            
            let text = userSearchBar.text?.firstLowercased
            filteredData = allUsers.filter({ ($0.username.localizedStandardContains(text!)) })

            searchTableView.reloadData()
        }
    }
    
    func listAllUsers()
    {
        // Clear the array that will hold all the users
        allUsers.removeAll()
        filteredData.removeAll()
        
        // No parameters will be sent, just a normal request
        Alamofire.request(searchFollowApi, method: .post).responseJSON
        { (response) in
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                let jsonData = result as! NSDictionary
                
                // Getting Data from response
                let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                
                // Getting second-level data
                // currentAvatar, username, experience, coins
                for object in userData
                {
                    guard let userName = object["username"] as? String,
                          let userAvatar = object["currentAvatar"] as? String,
                          let userExp = object["experience"] as? Int,
                          let userCoins = object["coins"] as? Int
                        else { print("Something from follow user is null"); return }
                    
                    // Save each user to the array
                    self.allUsers.append(Follow(followUsername: userName, followAvatar: userAvatar, followExp: userExp, followCoins: userCoins))
                }
                
                self.searchTableView.reloadData()
            }
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
    
    func simpleAlert(title: String, message: String)
    {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (alertAction) in
        }
        
        alert.addAction(okButton)
        
        present(alert, animated:true, completion: nil)
    }

    
}
