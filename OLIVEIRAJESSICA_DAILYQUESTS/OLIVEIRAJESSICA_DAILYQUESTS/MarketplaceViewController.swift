//
//  MarketplaceViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/12/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import UIKit

class MarketplaceViewController: UIViewController
{
    // Outlets
    @IBOutlet var marketButtons: [UIView]!
    @IBOutlet var marketUIViews: [UIView]!
    
    // Variable to receive coins value through segue
    var userCoins: Int?
    var username: String?
    var tempCoins: Int = 0
    
    // Variables
    var colorDefaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Rounding views' edges
        for view in marketButtons
        {
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
        }
        
        // Set the UIViews to the saved color theme from user defaults
        for view in marketUIViews
        {
            view.backgroundColor = colorDefaults.colorForKey(key: "currentColorTheme")
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBackOneLevel(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // The following segue passes the coins to the color themes view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Prepare the variable thar will be sent forward
        let playerCoins = userCoins!
        let playerUsername = username!
        
        // Passing the data
        guard let destination = segue.destination as? ColorThemesViewController else { return }
        destination.userCoins = playerCoins
        destination.username = playerUsername
    }
}
