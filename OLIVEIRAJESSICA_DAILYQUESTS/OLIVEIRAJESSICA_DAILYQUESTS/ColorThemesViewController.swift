//
//  ColorThemesViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/12/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class ColorThemesViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var userCoins_label: UILabel!
    @IBOutlet var purchaseButtons: [UIButton]!
    
    // Variables
    var userCoins: Int?
    var username: String?
    var userThemes: [Int] = []
    var colorThemes: [(red: Int, green: Int, blue: Int)] = [(104, 128, 144), (249, 234, 229), (85, 133, 131), (160, 199, 178), (48, 18, 34), (246, 210, 111), (55, 91, 121), (145, 221, 232), (211, 61, 75), (244, 237, 193), (142, 192, 182), (221, 235, 165)]
    let getAllUserThemes: String = "http://dailyquests.club/JessyServer/v1/getthemes.php"
    let coinsUpdate: String = "http://dailyquests.club/JessyServer/v1/coins_update.php"
    var addTheme: String = ""
    var price: Int = 10000
    var btnIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Rounding purchase buttons' edges
        for button in purchaseButtons
        {
            button.clipsToBounds = true
            button.layer.cornerRadius = 5
        }
        
        // Assigning received coins value to a local variable and updating label
        userCoins_label.text = "Your coins: \(userCoins!)"
        
        // Send a request to the database to retrieve which color themes the user has purchased up to now
        getUserAquiredColorThemes()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBackOneLevel(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purchaseColorTheme(_ sender: UIButton)
    {
        
        switch sender.tag
        {
        // Assign the api url depending on which button was pressed
        case 1:
            addTheme = "http://dailyquests.club/JessyServer/v1/themeupdatet2.php"
            btnIndex = 1
        case 2:
            addTheme = "http://dailyquests.club/JessyServer/v1/themeupdatet3.php"
            btnIndex = 2
        case 3:
            addTheme = "http://dailyquests.club/JessyServer/v1/themeupdatet4.php"
            btnIndex = 3
        case 4:
            addTheme = "http://dailyquests.club/JessyServer/v1/themeupdatet5.php"
            btnIndex = 4
        case 5:
            addTheme = "http://dailyquests.club/JessyServer/v1/themeupdatet6.php"
            btnIndex = 5
        default:
            print("No cases were found.")
        }
        
        // Send the selected api in order to request info from database
        addColorThemeToUserProfile(api: addTheme, themePrice: price, buttonIndex: btnIndex)
    }
    
    func addColorThemeToUserProfile(api: String, themePrice: Int, buttonIndex: Int)
    {
        // Set up the parameters that will be sent tot he database
        let parameters: Parameters = ["username":username!]
        
        // Making a request
        Alamofire.request(api, method: .post, parameters: parameters).responseJSON
        { (response) in
        
            // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let jsonData = result as! NSDictionary
                let returnMessage = jsonData.value(forKey: "message") as! String?
                
                if returnMessage == "Theme updated"
                {
                    // It's a success. Update user's coins to the database.
                    self.updateCoins(price: themePrice, buttonIndex: buttonIndex)
                    
                }
            }
        }
    }
    
    func updateCoins(price: Int, buttonIndex: Int)
    {
        // Subtracts color theme price from user's current coins
        let tempCoins = self.userCoins! - price
        
        // Set up the parameters
        let parameters: Parameters = ["username":username!, "coins":tempCoins]
        
        // Making a request
        Alamofire.request(coinsUpdate, method: .post, parameters: parameters).responseJSON
        { (response) in
        
            // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                let returnMessage = jsonData.value(forKey: "message") as! String?
                
                // If the coins were updated successfully, update the label on the screen as well as the button
                if returnMessage == "Coins updated"
                {
                    // Updates the label
                    self.userCoins_label.text = "Your coins: \(tempCoins)"
                    
                    // Change button's info
                    self.purchaseButtons[buttonIndex].isUserInteractionEnabled = false
                    self.purchaseButtons[buttonIndex].setTitle("OBTAINED", for: .normal)
                    self.purchaseButtons[buttonIndex].backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
    func getUserAquiredColorThemes()
    {
        // Set up the parameters that will be sent
        let parameters: Parameters = ["username":username!]
        
        // Making a request
        Alamofire.request(getAllUserThemes, method: .post, parameters: parameters).responseJSON
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
                    guard let colorThemeOne = object["t1"] as? Int,
                    let colorThemeTwo = object["t2"] as? Int,
                    let colorThemeThree = object["t3"] as? Int,
                    let colorThemeFour = object["t4"] as? Int,
                    let colorThemeFive = object["t5"] as? Int,
                    let colorThemeSix = object["t6"] as? Int
                        else { return }
                    
                    // Add values to an array
                    self.userThemes.append(colorThemeOne)
                    self.userThemes.append(colorThemeTwo)
                    self.userThemes.append(colorThemeThree)
                    self.userThemes.append(colorThemeFour)
                    self.userThemes.append(colorThemeFive)
                    self.userThemes.append(colorThemeSix)
                    
                    // Check which buttons will be available for the user based on the user's obtained color themes
                    self.updatePurchaseButtonsAtStart()
                }
            }
        }
    }
    
    func updatePurchaseButtonsAtStart()
    {
        var i = 0
        for colorTheme in userThemes
        {
            let tempCoins = userCoins ?? nil
            if colorTheme == 0
            {
                if tempCoins! >= 10000
                {
                    purchaseButtons[i].isUserInteractionEnabled = true
                    purchaseButtons[i].setTitle("PURCHASE", for: .normal)
                    purchaseButtons[i].backgroundColor = UIColor(displayP3Red: 122/255.0, green: 203/255.0, blue: 141/255.0, alpha: 1.0)
                    i += 1
                }
                else
                {
                    purchaseButtons[i].isUserInteractionEnabled = false
                    purchaseButtons[i].setTitle("PURCHASE", for: .normal)
                    purchaseButtons[i].backgroundColor = UIColor.lightGray
                    i += 1
                }
                
            }
            else if colorTheme == 1
            {
                purchaseButtons[i].isUserInteractionEnabled = false
                purchaseButtons[i].setTitle("OBTAINED", for: .normal)
                purchaseButtons[i].backgroundColor = UIColor.lightGray
                i += 1
            }
        }
    }
}
