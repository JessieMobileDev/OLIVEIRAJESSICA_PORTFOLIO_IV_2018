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
    
    // APIs urls
    let readExperience = "http://dailyquests.club/JessyServer/v1/getexp.php"
    let readCoins = "http://dailyquests.club/JessyServer/v1/getcoins.php"
    let readAchievements = "http://dailyquests.club/JessyServer/v1/getachievements.php"
    let readBadges = "http://dailyquests.club/JessyServer/v1/getbadges.php"
    
    // Variables
    var tempUsername: String = ""
    var tempEmail: String = ""
    var expCount: Int = 0
    var coinsCount: Int = 0
    var badgesCount: Int = 0
    var achieveCount: Int = 0
    
    // Variables
    //var receivedUserData: (username: String, email: String, currentAvatar: Int, exp: Int, coins: Int, badges: Int, achievements: Int)?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        
//        let parameters: Parameters = ["username":tempUsername]
//
//        // Making a request
//        Alamofire.request(readExperience, method: .post, parameters: parameters).responseJSON
//        { (response) in
//
//            print(response)
//
//            // Getting the json value from the server
//            if let result = response.result.value
//            {
//                let jsonData = result as! NSDictionary
//                 print(jsonData)
//                // If there is no error
//                //if (!(jsonData.value(forKey: "error") as! Bool))
//                //{
//                    // Getting Data from response
//                    let userData = jsonData.value(forKey: "Data") as! NSDictionary
//
//                    // Getting second-level data
//                    let userExp = userData.value(forKey: "experience") as! [Int]
//
//                    // Stores data locally only to update labels
//                    self.expCount = userExp[0]
//                    self.level_label.text = "Exp: \(self.expCount)"
//                //}
//
//
//            }
//        }
        
        
        
        
//        if let userName = defaultValues.string(forKey: "username")
//        {
//            // Updating username label
//            username_label.text = userName
//        }
//        else
//        {
//            switchToLogInScreen()
//        }
//
//        if let userEmail = defaultValues.string(forKey: "useremail")
//        {
//            // Updating email label
//            email_label.text = userEmail
//        }
//        else
//        {
//            switchToLogInScreen()
//        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goToMyQuests(_ sender: UIButton)
    {
        
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

    // Marketplace Button
    @IBAction func goToMarketplace(_ sender: UIButton)
    {
        // Sends to the marketplace screen
        performSegue(withIdentifier: "marketplaceGo", sender: self)
    }
    
    func retrieveUserData()
    {
        //let expParameters = Parameters = ["username":defaultValues.string(forKey: "username")]
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
