//
//  LogInViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/11/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class LogInViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var login_username_txtField: UITextField!
    @IBOutlet weak var login_pw_txtField: UITextField!
    @IBOutlet weak var msg: UILabel!
    
    // API url
    let login_url = "http://dailyquests.club/JessyServer/v1/login.php"
    
    // UserDefaults to store user data
    let defaultValues = UserDefaults.standard
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // If the user is already logged in switching to MainMenuViewController
        if defaultValues.string(forKey: "username") != nil
        {
            let mainMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuScreen") as! MainMenuViewController
            self.navigationController?.pushViewController(mainMenuViewController, animated: true)
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // Button to log-in
    @IBAction func loginUser(_ sender: UIButton)
    {
        // Getting the username and password
        let parameters: Parameters = ["username":login_username_txtField.text!, "password":login_pw_txtField.text!]
        
        
        // Making a post request
        Alamofire.request(login_url, method: .post, parameters: parameters).responseJSON
        { (response) in
            print("1. \(response)")
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                print("2. \(String(describing: response.result.value))")
                
                let jsonData = result as! NSDictionary
                print("3. \(jsonData)")
                
                // If there is no error
                if (!(jsonData.value(forKey: "error") as! Bool))
                {
                    // Getting the user from response
                    let user = jsonData.value(forKey: "user") as! NSDictionary
                    
                    // Getting user values
                    //let userId = user.value(forKey: "userId") as! Int
                    let userName = user.value(forKey: "username") as! String
                    let userEmail = user.value(forKey: "email") as! String
                    
                    // Saving user values to defaults
                    //self.defaultValues.set(userId, forKey: "userid")
                    self.defaultValues.set(userName, forKey: "username")
                    self.defaultValues.set(userEmail, forKey: "useremail")
                    
                    // Switching to the main menu screen
                    let mainMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuScreen") as! MainMenuViewController
                    self.navigationController?.pushViewController(mainMenuViewController, animated: true)
                    
                    self.dismiss(animated: false, completion: nil)
                }
                else
                {
                    // Error message in case of invalid credential
                    self.msg.text = "Invalid username or password!"
                }
            }
        }
    }
    
    
    @IBAction func dismissToRegister(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
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
