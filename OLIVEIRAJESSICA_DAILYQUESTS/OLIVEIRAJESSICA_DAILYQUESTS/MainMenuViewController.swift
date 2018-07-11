//
//  MainMenuViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/11/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

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
            username_label.text = defaultValues.string(forKey: "username")
            email_label.text = defaultValues.string(forKey: "useremail")
        }
        else
        {
            switchToLogInScreen()
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
