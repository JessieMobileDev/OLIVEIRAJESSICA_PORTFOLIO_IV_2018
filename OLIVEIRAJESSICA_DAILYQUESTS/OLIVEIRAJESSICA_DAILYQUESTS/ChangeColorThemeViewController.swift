//
//  ChangeColorThemeViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/19/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class ChangeColorThemeViewController: UIViewController
{
    // Outlets
    @IBOutlet var availableButtons: [UIButton]!
    @IBOutlet var selectedButtons: [UIButton]!
    
    
    // Variables
    var username: String?
    var userThemes: [Int] = []
    let getAllUserThemes: String = "http://dailyquests.club/JessyServer/v1/getthemes.php"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Retrieve user's collection of color theme
        getUserAquiredColorThemes()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
                        
                        // Check which color themes are available for the user to select
                        self.updateAvailableColorThemeButtons()
                    }
                }
        }
    }

    func updateAvailableColorThemeButtons()
    {
        var i = 0
        for colorTheme in userThemes
        {
            if colorTheme == 0
            {
                availableButtons[i].setImage(UIImage(named: "notObtainedYet"), for: .normal)
                i += 1
                
                
            }
            else if colorTheme == 1
            {
                // If it's the first color theme from the array, set to selected
                if i == 0
                {
                    availableButtons[i].setImage(UIImage(named: "notObtainedYet"), for: .normal)
                    selectedButtons[i].setImage(UIImage(named: "selectionBoxFilled"), for: .normal)
                    i += 1
                }
            }
        }
    }

}
