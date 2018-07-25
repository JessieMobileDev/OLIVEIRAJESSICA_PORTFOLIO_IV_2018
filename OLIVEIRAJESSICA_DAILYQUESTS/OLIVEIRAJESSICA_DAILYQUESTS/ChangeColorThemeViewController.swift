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
    var selectedBoxTheme: Int?
    var userThemes: [Int] = []
    let getAllUserThemes: String = "http://dailyquests.club/JessyServer/v1/getthemes.php"
    let updateCurrentTheme: String = "http://dailyquests.club/JessyServer/v1/currentthemeupdate.php"
    var selectedThemeTag: Int = 0
    var colorThemes: [(red: Int, green: Int, blue: Int)] = [(104, 128, 144), (85, 133, 131), (48, 18, 34), (55, 91, 121), (211, 61, 75), (142, 192, 182)]
    var colorDefaults = UserDefaults.standard
    
    // UIViews outlets to have their color changed once UserDefaults is triggered
    @IBOutlet weak var topMenuBarView: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Retrieve user's collection of color theme
        getUserAquiredColorThemes()
        
        // Change the UIView color according to the saved color in the user defaults
        topMenuBarView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")

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
                selectedButtons[i].setImage(UIImage(named: "selectionBoxEmpty"), for: .normal)
                selectedButtons[i].isUserInteractionEnabled = false
                i += 1
            }
            else if colorTheme == 1
            {
                // If it's the first color theme from the array, set to selected
                if i == 0
                {
                    availableButtons[i].setImage(UIImage(named: "obtained"), for: .normal)
                    i += 1
                }
                else
                {
                    availableButtons[i].setImage(UIImage(named: "obtained"), for: .normal)
                    selectedButtons[i].setImage(UIImage(named: "selectionBoxEmpty"), for: .normal)
                    i += 1
                }
                
            }
        }
        
        // Current selected color theme is automatically checked in the box
        selectedButtons[selectedBoxTheme!-1].setImage(UIImage(named: "selectionBoxFilled"), for: .normal)
        print("Int passed: \(selectedBoxTheme!)")
    }
    
    @IBAction func selectAColorThemeToUse(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 0:
            selectedThemeTag = 1
        case 1:
            selectedThemeTag = 2
        case 2:
            selectedThemeTag = 3
        case 3:
            selectedThemeTag = 4
        case 4:
            selectedThemeTag = 5
        case 5:
            selectedThemeTag = 6
        default:
            print("No cases were found.")
        }
        
        // Set all buttons to not be selected
        for button in selectedButtons
        {
            button.setImage(UIImage(named: "selectionBoxEmpty"), for: .normal)
        }
        
        // Set the chosen theme to be selected
        selectedButtons[selectedThemeTag-1].setImage(UIImage(named: "selectionBoxFilled"), for: .normal)
        
        // Write back to the currentTheme column in the database the exact one the user chose
        // Set up the parameters that will be sent to the database
        let parameters: Parameters = ["username":username!, "currentTheme":selectedThemeTag]
        
        // Making the request
        Alamofire.request(updateCurrentTheme, method: .post, parameters: parameters).responseJSON
        { (response) in
        
            // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                let returnMessage = jsonData.value(forKey: "message") as! String?
                
                // If the current theme was successfully updated, then change the color theme of the UIViews in the current screen
                if returnMessage == "Current Theme updated"
                {
                    // Save it to the USerDefaults
                    let tempRed = self.colorThemes[self.selectedThemeTag-1].red
                    let tempGreen = self.colorThemes[self.selectedThemeTag-1].green
                    let tempBlue = self.colorThemes[self.selectedThemeTag-1].blue
                    self.colorDefaults.setColor(color: UIColor(displayP3Red: CGFloat(Double(tempRed)/255.0), green: CGFloat(Double(tempGreen))/255.0, blue: CGFloat(Double(tempBlue))/255.0, alpha: 1.0), forKey: "currentColorTheme")
                    
                    // Update UIViews to the selected color
                    self.topMenuBarView.backgroundColor = self.colorDefaults.colorForKey(key: "currentColorTheme")
                }
            }
        }
    }
    
    
    @IBAction func goBackButton(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
