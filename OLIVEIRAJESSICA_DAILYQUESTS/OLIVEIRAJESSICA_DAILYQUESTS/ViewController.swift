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
    //let userInfo = ""
    
    // Variables
    var userData: (username: String, email: String, currentAvatar: Int, exp: Int, coins: Int, badges: Int, achievements: Int) = ("", "", 0, 0, 0, 0, 0)
    
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
                self.msg.text = returnMessage
                
                // If the user was successfully created, then move to the Main Menu Screen
                if returnMessage == "User created successfully"
                {
                    self.performSegue(withIdentifier: "registerGo", sender: self)
                }
            }
        }
        
        

    }
    
    

}

