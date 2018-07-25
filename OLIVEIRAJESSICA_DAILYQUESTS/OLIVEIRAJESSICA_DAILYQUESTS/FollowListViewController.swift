//
//  FollowListViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/24/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class FollowListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    // Variables
    var username: String?
    var followApi: String = ""
    var alert: UIAlertController!
    var okAction: UIAlertAction!
    var colorDefaults = UserDefaults.standard
    
    // Outlets
    @IBOutlet weak var followTableView: UITableView!
    @IBOutlet weak var topMenuBarView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Change the views color according to what is saved in the user defaults
        topMenuBarView.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Re-use an existing cell or creating a new one if needed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as? FollowListTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath)
        }
        
        return cell
    }
    
    @IBAction func goBack(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func followSomebody(_ sender: UIButton)
    {
        // TODO: Do api requests
    }
    
    func simpleAlert(title: String, message: String)
    {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (alertAction) in
        }
        
        alert.addAction(okButton)
        
        present(alert, animated:true, completion: nil)
    }
}
