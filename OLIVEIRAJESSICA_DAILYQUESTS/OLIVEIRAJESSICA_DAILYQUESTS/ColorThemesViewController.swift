//
//  ColorThemesViewController.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/12/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Alamofire
import UIKit

class ColorThemesViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var userCoins_label: UILabel!
    @IBOutlet var purchaseButtons: [UIButton]!
    
    // Variable to receive the passed data
    var userCoins: Int?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Rounding purchase buttons' edges
        for button in purchaseButtons
        {
            button.clipsToBounds = true
            button.layer.cornerRadius = 5
        }
        
        // Assigning received coins value to a local variable and updating label
        userCoins_label.text = "Your coins: \(userCoins!)"
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBackOneLevel(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func retrieveCoins()
    {
        
    }
}
