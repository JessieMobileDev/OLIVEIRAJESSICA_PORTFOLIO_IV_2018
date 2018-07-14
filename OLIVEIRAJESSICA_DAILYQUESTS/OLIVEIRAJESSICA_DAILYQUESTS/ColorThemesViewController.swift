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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Rounding purchase buttons' edges
        for button in purchaseButtons
        {
            button.clipsToBounds = true
            button.layer.cornerRadius = 5
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
    
    func retrieveCoins()
    {
        
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
