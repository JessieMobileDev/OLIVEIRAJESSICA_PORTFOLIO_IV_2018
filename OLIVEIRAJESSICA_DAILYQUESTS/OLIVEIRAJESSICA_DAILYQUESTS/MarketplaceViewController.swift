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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Rounding views' edges
        for view in marketButtons
        {
            view.clipsToBounds = true
            view.layer.cornerRadius = 5
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goToColorThemes(_ sender: UIButton)
    {
        performSegue(withIdentifier: "colorthemesGo", sender: self)
    }
    
    @IBAction func goBackOneLevel(_ sender: UIButton)
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
