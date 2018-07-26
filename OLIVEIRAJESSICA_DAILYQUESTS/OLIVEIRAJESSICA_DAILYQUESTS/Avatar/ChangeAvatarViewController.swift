//
//  ChangeAvatarViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/25/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class ChangeAvatarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    // Outlets
    @IBOutlet weak var availableAvatarCollectionView: UICollectionView!
    @IBOutlet weak var topMenuBarView: UIView!
    
    // Variables
    var username: String?
    let getAllAvatars: String = "http://dailyquests.club/JessyServer/v1/get_avatars.php"
    let currentAvatarUpdate: String = "http://dailyquests.club/JessyServer/v1/currentavatarupdate.php"
    let updateAvatars: [String] = []
    var numbers: [Int] = []
    var avatars: [String] = []
    var obtainedAvatars: [Int] = []
    var colorDefaults = UserDefaults.standard
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Update the views with the color saved on userdefaults
        topMenuBarView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
        
        // Get all obtained avatars and display on the collection view
        getAllObtainedAvatars()

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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "changeAvatarCell", for: indexPath) as? ChangeAvatarCollectionViewCell else { return collectionView.dequeueReusableCell(withReuseIdentifier: "changeAvatarCell", for: indexPath) }
        
        // Determine which card the user is trying to select and apply the image to the cell
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
        // Show an alert asking if the user wants to change to that avatar
        let alert = UIAlertController(title: "Change avatar", message: "Do you want to change your current avatar to this one?", preferredStyle: UIAlertControllerStyle.alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            // With the confirmation of the alert, update the currentavatar to the database
            self.updateCurrentAvatar(avatarIndex: self.avatars[indexPath.row])
        }
        let noButton = UIAlertAction(title: "No", style: .cancel) { (alertAction) in
        }
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        
        present(alert, animated:true, completion: nil)
    }
    
    func getAllObtainedAvatars()
    {
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
                            if numb == 1
                            {
                                self.avatars.append("AF\(offset+1)")
                            }
                        }
                        else
                        {
                            if numb == 1
                            {
                                self.avatars.append("AM\(offset-11)")
                            }
                        }
                        
                    }
                    
                    DispatchQueue.main.async
                    {
                        self.availableAvatarCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func updateCurrentAvatar(avatarIndex: String)
    {
        // Remove the letter A from the avatar naming convetion
        var name = avatarIndex
        var tempIndex = ""
        if avatarIndex.contains("A")
        {
            name.removeFirst()
            tempIndex = name
        }

        
        // Set up the parameters to be sent in the request to the database
        let parameters: Parameters = ["username":username!, "currentAvatar":tempIndex]
        
        // Making a request
        Alamofire.request(currentAvatarUpdate, method: .post, parameters: parameters).responseJSON
        { (response) in
            
            // Getting the json value from the server
            if let result = response.result.value
            {
                // Converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                let returnMessage = jsonData.value(forKey: "message") as! String?
                
                // If the update was successful, save to the user defaults
                if returnMessage == "Current Avatar updated"
                {
                    print("Current avatar updated successfully")
                }
                else
                {
                    print("Current avatar not updated")
                }
            }
            
        }
    }
    
    
    
    
}
