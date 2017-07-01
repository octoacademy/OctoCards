//
//  SettingsManager.swift
//  Octo Cards
//
//  Created by Linda Ho on 6/27/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import Foundation

class SettingsManager {
    static var notificationTime = Date()
    
    
    func dateFormatter(sender: Date) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        print("Current time is: \(SettingsManager.notificationTime.description))")
    }
    //SettingsManager.dateFormatter(from: SettingsManager.notificationTime)
    
}
