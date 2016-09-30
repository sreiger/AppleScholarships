//
//  ControllerButton.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-20.
//  Copyright © 2016 Shaun Reiger. All rights reserved.
//

import SpriteKit

enum ControllerInput: Int {
    case up
    case left
    case down
    case right
}

class ControllerButton: SKSpriteNode {
    
    var hitbox: ((CGPoint) -> Bool)? // a variable asigned as CGPoint but will reture true or false if a point exists
    
    var value: ControllerInput?
    
    convenience init(imageNamed name: String, value: ControllerInput, position: CGPoint) {
        self.init(imageNamed: name)
        self.texture?.filteringMode = .nearest // texture can be nil
        self.setScale(2.0) //default was 2.0
        self.alpha = 0.2
        self.position = position
        
        self.value = value
        
        hitbox = { (location: CGPoint) -> Bool in // block statment
            return self.contains(location)
        }
    }
    
    func hitboxContainsPoint(_ location: CGPoint) -> Bool {
        return hitbox!(location)
    }
    
}
