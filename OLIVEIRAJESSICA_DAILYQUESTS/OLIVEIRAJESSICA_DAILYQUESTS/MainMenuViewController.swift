//
//  MainMenuViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/11/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class MainMenuViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
    @IBOutlet weak var level_label: UILabel!
    @IBOutlet weak var coins_label: UILabel!
    @IBOutlet weak var badges_label: UILabel!
    @IBOutlet weak var achievements_label: UILabel!
    @IBOutlet var mainMenuButtons: [UIView]!
    @IBOutlet weak var userAvatar: UIImageView!
    
    // UIView outlets that will have thier color changed
    @IBOutlet var mainMenuUIViews: [UIView]!
    
    // APIs urls
    let readExperience = "http://dailyquests.club/JessyServer/v1/getexp.php"
    let readCoins = "http://dailyquests.club/JessyServer/v1/getcoins.php"
    let readAchievements = "http://dailyquests.club/JessyServer/v1/getachievements.php"
    let readBadges = "http://dailyquests.club/JessyServer/v1/getbadges.php"
    var readAPIs: [String] = ["http://dailyquests.club/JessyServer/v1/getexp.php", "http://dailyquests.club/JessyServer/v1/getcoins.php", "http://dailyquests.club/JessyServer/v1/getachievements.php", "http://dailyquests.club/JessyServer/v1/getbadges.php"]
    let readCurrentAvatar = "http://dailyquests.club/JessyServer/v1/getcurrentavatar.php"
    let getCurrentTheme = "http://dailyquests.club/JessyServer/v1/getcurrenttheme.php"
    
    // Variables
    var tempUsername: String = ""
    var tempEmail: String = ""
    var expCount: Int = 0
    var coinsCount: Int = 0
    var badgesCount: Int = 0
    var achieveCount: Int = 0
    var userStatus: [Int] = []
    var colorDefaults = UserDefaults.standard
    var colorThemes: [(red: Int, green: Int, blue: Int)] = [(104, 128, 144), (85, 133, 131), (48, 18, 34), (55, 91, 121), (211, 61, 75), (142, 192, 182)]
    var selectedBoxTheme: Int = 0
    
    var exponent: Double = 1.5
    var baseExp: Int = 1000
    var levelCount: Int = 1
    var currentMaxPerLevel: Double = 0.0
    var remainingExp: Double = 0.0
    var nextLevelMaxExp: Double = 0.0

    
    // Variables
    //var receivedUserData: (username: String, email: String, currentAvatar: Int, exp: Int, coins: Int, badges: Int, achievements: Int)?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Rounding the edges of the options views
        for view in mainMenuButtons
        {
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
        }
        
        // Getting user data from defaults
        let defaultValues = UserDefaults.standard
        
        if defaultValues.string(forKey: "username") != nil && defaultValues.string(forKey: "useremail") != nil
        {
            // Updating only username and email labels
            tempUsername = defaultValues.string(forKey: "username")!
            tempEmail = defaultValues.string(forKey: "useremail")!
            username_label.text = tempUsername
            email_label.text = tempEmail
        }
        else
        {
            switchToLogInScreen()
        }
        
        // Getting experience, coins, achievements and badges count from database
        retrieveUserData()
        
        // Updates current avatar
        getCurrentAvatar()
        
        // Update UIView colors using color defaults
        updateUIViewColors()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // When the "quests screen" is dimissed, the user info should be updated
        retrieveUserData()
        
        // Updates current avatar
        getCurrentAvatar()
        
        // Update UIView colors using color defaults
        updateUIViewColors()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goToMyQuests(_ sender: UIButton)
    {
        performSegue(withIdentifier: "myQuestsGo", sender: self)
    }
    
    // Log off Button
    @IBAction func logoffCurrentUser(_ sender: UIButton)
    {
        // Removing values from default
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        // Switching back to the log-in screen
        switchToLogInScreen()
    }
    
    func switchToLogInScreen()
    {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogInScreen") as! LogInViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    

    
    // The following segue passes the coins to the marketplace view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "myQuestsGo"
        {
            // Prepare the variable that will be sent forward
            let playerUsername = tempUsername
            let userCoins = coinsCount
            let userExp = expCount
            
            // Passing data
            guard let destination = segue.destination as? MyQuestsViewController else { return }
            destination.username = playerUsername
            destination.userCoins = userCoins
            destination.userExp = userExp
        }
        else if segue.identifier == "marketplaceGo"
        {
            // Prepare the variable that will be sent forward
            let playerCoins = coinsCount
            let playerUsername = tempUsername
            
            // Passing the data
            guard let destination = segue.destination as? MarketplaceViewController else { return }
            destination.userCoins = playerCoins
            destination.username = playerUsername
        }
        else if segue.identifier == "followListGo"
        {
            // Prepare the variable that will be sent forward
            let playerUsername = tempUsername
            
            // Passing data
            guard let destination = segue.destination as? FollowListViewController else { return }
            destination.username = playerUsername
        }
        else if segue.identifier == "changeColorThemeGo"
        {
            // Prepare the variable that will be sent forward
            let playerUsername = tempUsername
            
            // Passing data
            guard let destination = segue.destination as? ChangeColorThemeViewController else { return }
            destination.username = playerUsername
            destination.selectedBoxTheme = selectedBoxTheme
        }
        else if segue.identifier == "achievementsGo"
        {
            // Prepare the variable that will be sent forward
            let playerUsername = tempUsername
            
            // Passing data
            guard let destination = segue.destination as? AchievementsViewController else { return }
            destination.username = playerUsername
        }
    }
    
    
    func retrieveUserData()
    {
        // Clears userStatus array before adding
        userStatus.removeAll()
        
        // Parameters will be the same for all read API requests
        let parameters: Parameters = ["username":tempUsername]
        
        // For each API in my API array, do the same request
        for api in readAPIs
        {
            // Making a request
            Alamofire.request(api, method: .post, parameters: parameters).responseJSON
            { (response) in
                    
                    print(response)
                    
                    // Getting the json value from the server
                    if let result = response.result.value
                    {
                        let jsonData = result as! NSDictionary
                        
                        // Getting Data from response
                        let userData = jsonData.value(forKey: "Data") as! [NSDictionary]

                        // Getting second-level data based on each api
                        switch self.readAPIs.index(of: api)
                        {
                            // Each case will collect the data, store in a variable and display on labels
                            case 0:
                                let userExp = userData[0].value(forKey: "experience") as! Int
                                self.expCount = userExp
                                
                                // Check user's current level and remaining experience
                                self.levelsBreakDown()
                                
                                // Calculates how much experience you're at from the next level
                                //let nextLevelPercentage = (self.remainingExp * 100)/self.nextLevelMaxExp
                                let nextLevelPercentage = (100 - (self.remainingExp * 100.0)/self.nextLevelMaxExp)
                                
                                // Round the float to 2 decimal spaces
                                let nextPerc = String(format: "%.2f", nextLevelPercentage as CVarArg)
                                self.level_label.text = "Level: \(self.levelCount) [ \(nextPerc)% ]"
                            case 1:
                                let userCoins = userData[0].value(forKey: "coins") as! Int
                                self.coinsCount = userCoins
                                self.coins_label.text = "\(self.coinsCount) coins"
                            case 2:
                                let userAchieve = userData[0].value(forKey: "achievements") as! Int
                                self.achieveCount = userAchieve
                                self.achievements_label.text = "Achievements: \(self.achieveCount)"
                            case 3:
                                let userBadges = userData[0].value(forKey: "badges") as! Int
                                self.badgesCount = userBadges
                                self.badges_label.text = "Badges: \(self.badgesCount)"
                            default:
                                print("Array count is wrong.")
                        }
                        
                    }
            }
        }
    }
    
    func levelsBreakDown()
    {
        let baseLvl: Int = 1
        var counter: Int = 0
        var hasFoundMatchingLevel: Bool = false

        // While user experience is not higher or equal to the formula outcome, keep adding 1 to the counter until it finds a match
        while hasFoundMatchingLevel == false
        {
            // Base experience per level formula
            // Counter will change the outcome depending on the while loop below
            currentMaxPerLevel = (Double(baseExp) * (Double(baseLvl + counter) * exponent))
            
            if Double(expCount) > currentMaxPerLevel
            {
                counter += 1
            }
            else if Double(self.expCount) == self.currentMaxPerLevel
            {
                counter += 1
                
                // Subtract the user's experience from the max experience from the matching level
                remainingExp = currentMaxPerLevel - Double(expCount)
                levelCount = counter
                
                // Checks the next level's max experience
                //let tempCurrentMaxPerLevel = (Double(self.baseExp) * (Double(baseLvl + (counter + 1)) * self.exponent))
                //nextLevelMaxExp = tempCurrentMaxPerLevel
                nextLevelMaxExp = Double(baseExp) * exponent
                
                // It found a matching level
                hasFoundMatchingLevel = true
            }
            else
            {
                // Subtract the user's experience from the max experience from the matching level
                remainingExp = currentMaxPerLevel - Double(expCount)
                levelCount = counter
                
                
                
                //print("Level count: \(levelCount)")
                
                // Checks the next level's max experience
                //let tempCurrentMaxPerLevel = (Double(baseExp) * (Double(baseLvl + counter) * exponent))
                nextLevelMaxExp = Double(baseExp) * exponent
                
                //print("remaining exp: \(remainingExp) -- nextLevelMaxExp: \(nextLevelMaxExp) -- level count: \(levelCount) -- Percentage for next level: \((remainingExp * 100.0)/nextLevelMaxExp) -- Percentage in reverse: \((100 - (remainingExp * 100.0)/nextLevelMaxExp))")
                
                // It found a matching level
                hasFoundMatchingLevel = true
            }
        }
    }
    
    func getCurrentAvatar()
    {
        // Setting the parameter to be sent
        let parameters: Parameters = ["username":tempUsername]
        
        // Making a request
        Alamofire.request(readCurrentAvatar, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                let jsonData = result as! NSDictionary
                
                // Getting Data from response
                let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                
                // Getting second-level data
                guard let userCurrentAvatar = userData[0]["currentAvatar"] as? String else { return }
                
                let tempAvatar = "A\(userCurrentAvatar)"
                
                // Set the current avatar to the image view
                self.userAvatar.image = UIImage(named: tempAvatar)
            }
        }
    }
    
    func updateUIViewColors()
    {
        // Set up the parameters that will be sent to the database
        let parameters: Parameters = ["username":tempUsername]
        
        // Making the request
        Alamofire.request(getCurrentTheme, method: .post, parameters: parameters).responseJSON
            { (response) in
                
                // Getting the json value from the server
                if let result = response.result.value
                {
                    // Converting it as NSDictionary
                    let jsonData = result as! NSDictionary
                    
                    // Getting Data from response
                    let userData = jsonData.value(forKey: "Data") as! [NSDictionary]
                    
                    let currentUserTheme = userData[0].value(forKey: "currentTheme") as! Int
                    self.selectedBoxTheme = currentUserTheme
                    
                    // Save the current theme to the userdefaults so it can be used throughout the screens
                    let tempRed = self.colorThemes[currentUserTheme-1].red
                    let tempGreen = self.colorThemes[currentUserTheme-1].green
                    let tempBlue = self.colorThemes[currentUserTheme-1].blue
                    
                    self.colorDefaults.setColor(color: UIColor(displayP3Red: CGFloat(Double(tempRed)/255.0), green: CGFloat(Double(tempGreen))/255.0, blue: CGFloat(Double(tempBlue))/255.0, alpha: 1.0), forKey: "currentColorTheme")
                    
                    // Update the UIViews from the current screen
                    for view in self.mainMenuUIViews
                    {
                        view.backgroundColor = self.colorDefaults.colorForKey(key: "currentColorTheme")
                    }
                }
        }
    }
}
