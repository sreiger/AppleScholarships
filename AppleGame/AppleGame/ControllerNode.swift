//
//  ControllerNode.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-24.
//  Copyright © 2016 Shaun Reiger. All rights reserved.
//

import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class ControllerNode: SKNode {
    
    let buttonDirUp = ControllerButton(imageNamed: "button_dir_up_0", value: .up,
                                       position:  CGPoint(x: 100, y: 150))
    let buttonDirLeft = ControllerButton(imageNamed: "button_dir_left_0", value: .left,
                                         position: CGPoint(x: 50, y: 100))
    let buttonDirDown = ControllerButton(imageNamed: "button_dir_down_0", value: .down,
                                         position: CGPoint(x: 100, y:50))
    let buttonDirRight = ControllerButton(imageNamed: "button_dir_right_0", value: .right,
                                          position: CGPoint(x: 150,y: 100))
    
    var pressedButtons = [ControllerButton]()

    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(position: CGPoint) {
        self.init()
        self.position = position
    }
    
    override init() {
        super.init()
        
        self.isUserInteractionEnabled = true // touches are disabled by default
        self.zPosition = 500 // this controller is above everything else (was 500)
        
        self.addChild(buttonDirUp)
        self.addChild(buttonDirLeft)
        self.addChild(buttonDirDown)
        self.addChild(buttonDirRight)

        
        
        let l = 94.0 as CGFloat
        let x0 = 90.0 as CGFloat
        let y0 = 100.0 as CGFloat
        let angle = CGFloat(tan(M_PI/3))
        
        buttonDirUp.hitbox = { (location: CGPoint) -> Bool in
            let is_above_y0 = location.y - y0 > 0
            let is_within_angle = (abs(location.x - x0) <= abs(location.y - y0) * angle)
            let is_within_radius = (location.x - x0) ** 2 + (location.y - y0) ** 2 <= l ** 2
            return is_above_y0 && is_within_angle && is_within_radius
        }
        buttonDirLeft.hitbox = {
            (location: CGPoint) -> Bool in
            let is_left_of_x0 = location.x - x0 < 0
            let is_within_angle = (abs(location.x - x0) * angle >= abs(location.y - y0))
            let is_within_radius = (location.x - x0) ** 2 + (location.y - y0) ** 2 <= l ** 2
            return is_left_of_x0 && is_within_angle && is_within_radius
        }
        buttonDirDown.hitbox = {
            (location: CGPoint) -> Bool in
            let is_below_of_y0 = location.y - y0 < 0
            let is_within_angle = (abs(location.x - x0) <= abs(location.y - y0) * angle)
            let is_within_radius = (location.x - x0) ** 2 + (location.y - y0) ** 2 <= l ** 2
            return is_below_of_y0 && is_within_angle && is_within_radius
        }
        buttonDirRight.hitbox = {
            (location: CGPoint) -> Bool in
            let is_right_of_x0 = location.x - x0 > 0
            let is_within_angle = (abs(location.x - x0) * angle >= abs(location.y - y0))
            let is_within_radius = (location.x - x0) ** 2 + (location.y - y0) ** 2 <= l ** 2
            return is_right_of_x0 && is_within_angle && is_within_radius
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)

            for button in [buttonDirUp, buttonDirLeft, buttonDirDown, buttonDirRight] {
                if button.hitboxContainsPoint(location) && pressedButtons.index(of: button) == nil {
                    pressedButtons.append(button)
                }
            }
            for button in [buttonDirUp, buttonDirLeft, buttonDirDown, buttonDirRight] {
                if pressedButtons.index(of: button) == nil {
                    button.alpha = 0.2
                }
                else {
                    button.alpha = 0.8
                }
            }
        }
    }
    
        
    

    
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            for button in [buttonDirUp, buttonDirLeft, buttonDirDown, buttonDirRight] {
                // if I get off the button where my finger was before
                if button.hitboxContainsPoint(previousLocation)
                    && !button.hitboxContainsPoint(location) {
                    // I remove it from the list
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
                    // if I get on the button where I wasn't previously
                else if !button.hitboxContainsPoint(previousLocation)
                    && button.hitboxContainsPoint(location)
                    && pressedButtons.index(of: button) == nil {
                    // I add it to the list
                    pressedButtons.append(button)
                }
            }
        }
        // update transparency for all 4 buttons
        for button in [buttonDirUp, buttonDirLeft, buttonDirDown, buttonDirRight] {
            if pressedButtons.index(of: button) == nil {
                button.alpha = 0.2
            }
            else {
                button.alpha = 0.8
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEndedOrCancelled(touches, withEvent: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEndedOrCancelled(touches, withEvent: event)
    }
    
    func touchesEndedOrCancelled(_ touches: Set<NSObject>?, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches! {// Added ! not sure if its needed
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            
            for button in [buttonDirUp, buttonDirLeft, buttonDirDown, buttonDirRight] {
                if button.hitboxContainsPoint(location) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
                else if (button.hitboxContainsPoint(previousLocation)) {
                    let index = pressedButtons.index(of: button)
                    if index != nil {
                        pressedButtons.remove(at: index!)
                    }
                }
            }
        }
        for button in [buttonDirUp, buttonDirLeft, buttonDirDown, buttonDirRight] {
            if pressedButtons.index(of: button) == nil {
                button.alpha = 0.2
            }
            else {
                button.alpha = 0.8
            }
        }
    }
    
    func pressedDirections() -> [ControllerInput] {
        return self.pressedButtons.map({b in b.value!})
    }
    
}
