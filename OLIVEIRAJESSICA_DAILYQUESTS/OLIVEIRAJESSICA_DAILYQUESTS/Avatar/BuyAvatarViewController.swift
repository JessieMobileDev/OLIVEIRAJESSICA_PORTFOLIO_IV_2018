//
//  BuyAvatarViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/25/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class BuyAvatarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    // Outlets
    @IBOutlet weak var buyAvatarCollectionView: UICollectionView!
    @IBOutlet weak var userCoins_label: UILabel!
    @IBOutlet weak var topMenuBarView: UIView!
    
    // Variables
    var username: String?
    var userCoins: Int?
    let getAllAvatars: String = "http://dailyquests.club/JessyServer/v1/get_avatars.php"
    let coinsUpdate: String = "http://dailyquests.club/JessyServer/v1/coins_update.php"
    var avatars: [String] = []
    var numbers: [Int] = []
    let price: Int = 5000
    let colorDefaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Update the views with the color saved on userdefaults
        topMenuBarView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
        
        // Update coins label
        userCoins_label.text = userCoins!.description
        
        // Look for all the user's not obtained avatars and display in the collection view
        getAllNotObtainedAvatars()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - UICollectionView Protocol Methods
    // Required methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buyAvatarCell", for: indexPath) as? BuyAvatarCollectionViewCell else { return collectionView.dequeueReusableCell(withReuseIdentifier: "buyAvatarCell", for: indexPath) }
        
        // Determine which avatar is available for the user
        cell.avatar_image.image = UIImage(named: self.avatars[indexPath.row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.width/3 - 20
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if self.userCoins! >= 5000
        {
            // Show an alert asking if the user wants to buy the selected avatar
            let alert = UIAlertController(title: "Buy avatar", message: "5.000 coins", preferredStyle: UIAlertControllerStyle.alert)
            
            let yesButton = UIAlertAction(title: "Buy", style: .default) { (alertAction) in
                
                // With the confirmation of the alert, update the currentavatar to the database
                self.updateSpecificAvatar(avatarIndex: self.avatars[indexPath.row], singleIndex: indexPath.row)
            }
            let noButton = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            present(alert, animated:true, completion: nil)
        }
        else if self.userCoins! < 5000
        {
            // Show an alert asking if the user wants to buy the selected avatar
            let alert = UIAlertController(title: "You're \(price-userCoins!) coins short", message: "Complete more quests to earn more coins!", preferredStyle: UIAlertControllerStyle.alert)
            
            let yesButton = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                
            
            }
            let noButton = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            present(alert, animated:true, completion: nil)
        }
        
    }
    
    func getAllNotObtainedAvatars()
    {
        // Clear array that is being used to save the not obtained avatars
        self.avatars.removeAll()
        
        // Set up the parameters to be sent in the request
        let parameters: Parameters = ["username":username!]
        
        // Making a request
        Alamofire.request(getAllAvatars, method: .post, parameters: parameters).responseJSON
        { (response) in
                
                // Getting the json value from the server
                if let result = response.result.value
                {
                    let jsonData = result as! NSDictionary
                    
                    // Getting Data from response
                    let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                    
                    // Getting second-level data
                    for object in userData
                    {
                        guard let AF1 = object["f1"] as? Int,
                            let AF2 = object["f2"] as? Int,
                            let AF3 = object["f3"] as? Int,
                            let AF4 = object["f4"] as? Int,
                            let AF5 = object["f5"] as? Int,
                            let AF6 = object["f6"] as? Int,
                            let AF7 = object["f7"] as? Int,
                            let AF8 = object["f8"] as? Int,
                            let AF9 = object["f9"] as? Int,
                            let AF10 = object["f10"] as? Int,
                            let AF11 = object["f11"] as? Int,
                            let AF12 = object["f12"] as? Int,
                            let AM1 = object["m1"] as? Int,
                            let AM2 = object["m2"] as? Int,
                            let AM3 = object["m3"] as? Int,
                            let AM4 = object["m4"] as? Int,
                            let AM5 = object["m5"] as? Int,
                            let AM6 = object["m6"] as? Int,
                            let AM7 = object["m7"] as? Int,
                            let AM8 = object["m8"] as? Int,
                            let AM9 = object["m9"] as? Int,
                            let AM10 = object["m10"] as? Int,
                            let AM11 = object["m11"] as? Int,
                            let AM12 = object["m12"] as? Int
                            else { return }
                        
                        // Add values to an array
                        self.numbers = [AF1, AF2, AF3, AF4, AF5, AF6, AF7, AF8, AF9, AF10, AF11, AF12, AM1, AM2, AM3, AM4, AM5, AM6, AM7, AM8, AM9, AM10, AM11, AM12]
                        
                        for (offset, numb) in self.numbers.enumerated()
                        {
                            if offset >= 0 && offset <= 11
                            {
                                if numb == 0
                                {
                                    self.avatars.append("AF\(offset+1)")
                                }
                            }
                            else
                            {
                                if numb == 0
                                {
                                    self.avatars.append("AM\(offset-11)")
                                }
                            }
                            
                        }
                        
                        DispatchQueue.main.async
                        {
                            self.buyAvatarCollectionView.reloadData()
                        }
                    }
                }
        }
    }
    
    func updateSpecificAvatar(avatarIndex: String, singleIndex: Int)
    {
        // Remove the letter A from the avatar naming convetion
        var name = avatarIndex
        var tempIndex = ""
        if avatarIndex.contains("A")
        {
            name.removeFirst()
            tempIndex = name
        }
        
        // Turn the letter lowercase, because that's how it shows in the api url
        let tempName = tempIndex.lowercased()
        
        let specificAvatarApi = "http://dailyquests.club/JessyServer/v1/avatar_update\(tempName).php"
        
        // Set up the parameters that will be sent with the request
        let parameters: Parameters = ["username":username!]
        
        // Making the request
        Alamofire.request(specificAvatarApi, method: .post, parameters: parameters).responseJSON
        { (response) in
                
           // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                let returnMessage = jsonData.value(forKey: "message") as! String?
                
                // If the update was successful, reload data on collection view to remove the obtained avatar from the list
                if returnMessage == "Avatar updated"
                {
//                    DispatchQueue.main.async
//                    {
//                        self.buyAvatarCollectionView.reloadData()
//                    }
                    //self.buyAvatarCollectionView.reloadData()
                    // Update user's coins in the database
                    self.updateUserCoins(index: singleIndex)
                }
            }
        }
    }
    
    func updateUserCoins(index: Int)
    {
        // Subtracts avatar price from user's current coins
        let tempCoins = self.userCoins! - price
        
        // Set up parameters
        let parameters: Parameters = ["username":username!, "coins":tempCoins]
        
        // Making the request
        Alamofire.request(coinsUpdate, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                let returnMessage = jsonData.value(forKey: "message") as! String?
                
                // If the user's coins were updated successfully to the database, then update the coins label
                if returnMessage == "Coins updated"
                {
                    // Remove the selected item from the array that holds all the not obtained avatars
                    self.avatars.remove(at: index)
                    
                    DispatchQueue.main.async
                    {
                        self.userCoins_label.text = tempCoins.description
                        self.buyAvatarCollectionView.reloadData()
                    }
                }
            }
        }
    }
}
