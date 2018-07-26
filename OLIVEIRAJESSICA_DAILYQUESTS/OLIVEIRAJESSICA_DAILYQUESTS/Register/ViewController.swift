//
//  ViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/10/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class ViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var reg_username_txtField: UITextField!
    @IBOutlet weak var reg_email_txtField: UITextField!
    @IBOutlet weak var reg_pw_txtField: UITextField!
    @IBOutlet weak var msg: UILabel!
    
    // APIs urls
    let register_url = "http://dailyquests.club/JessyServer/v1/register.php"
    
    // Variables
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
   
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func registerUser(_ sender: UIButton)
    {
        // Creating parameters for the post request
        let parameters: Parameters = ["username":reg_username_txtField.text!, "email":reg_email_txtField.text!, "password":reg_pw_txtField.text!]
        
        // Sending http post request
        Alamofire.request(register_url, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            print(response)
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                // Displaying the message in label for testing purposes
                let returnMessage = jsonData.value(forKey: "message") as! String?
                let userId = jsonData.value(forKey: "user") as! Int?
                self.msg.text = returnMessage
                print(returnMessage!)
                
                // If the user was successfully created, then move to the Main Menu Screen
                if returnMessage == "User created successfully"
                {
                    // Save new account info to user defaults
                    self.defaultValues.set(userId, forKey: "userId")
                    self.defaultValues.set(self.reg_username_txtField.text!, forKey: "username")
                    self.defaultValues.set(self.reg_email_txtField.text!, forKey: "useremail")
                    
                    // Perform segue to the main menu screen
                    self.performSegue(withIdentifier: "registerGo", sender: self)
                }
                
                // Clears whatever is still written in the text fields
                self.reg_username_txtField.text = ""
                self.reg_pw_txtField.text = ""
                self.reg_email_txtField.text = ""
                self.msg.text = ""
                
            }
        }
        
        

    }
    
    

}

