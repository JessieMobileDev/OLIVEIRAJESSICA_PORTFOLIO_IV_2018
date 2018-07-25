//
//  UserDefaultsExtension.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/25/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import UIKit
import Foundation

extension UserDefaults
{
    // To save a color
    func setColor(color: UIColor?, forKey key: String)
    {
        var colorData: NSData?
        
        if let color = color
        {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        
        set(colorData, forKey: key) // UserDefault Built-in Method into "Any?"
    }
    
    // To get a color
    func colorForKey(key: String) -> UIColor?
    {
        var color: UIColor?
        
        if let colorData = data(forKey: key)
        {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        
        return color
    }
}
