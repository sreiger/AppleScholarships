//
//  File.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-20.
//  Copyright © 2016 Shaun Reiger. All rights reserved.
//

import Foundation

class Settings {
    var virtualPad: Bool
    
    static let sharedInstance = Settings()
    
    init() {
        virtualPad = false
    }
}
