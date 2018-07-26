//
//  StringExtension.swift
//  OLIVEIRAJESSICA_DAILYQUESTS
//
//  Created by Jessica on 7/26/18.
//  Copyright © 2018 Jessica. All rights reserved.
//

import Foundation

extension StringProtocol
{
    var firstLowercased: String
    {
        guard let first = first else { return "" }
        return String(first).lowercased() + dropFirst()
    }
}
