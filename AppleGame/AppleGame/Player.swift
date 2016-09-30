//
//  Player.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-24.
//  Copyright © 2016 Shaun Reiger. All rights reserved.
//

import SpriteKit

enum CharacterDirection : Int {
    case up
    case left
    case down
    case right
}

class Player: SKSpriteNode {
    let sprites = SKTextureAtlas(named:"sprites")
    //let playerSprite = textureAtlas.
    
    // initialize all the ticks
    var tick = 0
    
    // where the character is facing to (Up, Down, Left, Right)
    var currentDirection: CharacterDirection?
    // where the character was facing to before doing an action
    var lastDirection: CharacterDirection?
    // point where the character is heading to (Finger touch navigation)
    var destination: CGPoint?
    
    // the default walking speed of a character
    var defaultSpeed = CGFloat(2.4)
    // the walking speed a the beginning
    var walkingSpeed = CGFloat(0.0)
    
    convenience init(named: String) {
        
        
        
        let texture = SKTextureAtlas(named:"sprites").textureNamed(named)
        
        
        texture.filteringMode = .nearest
        self.init(texture: texture)
        self.setScale(2.0)
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        walkingSpeed = defaultSpeed
        lastDirection = .down
        self.zPosition = 10
    }
    
    // the walk animation from the controller inputs
    func walk(_ directions: [ControllerInput]) {
        // We will complete this method later
        var walkingSpeed: CGFloat = 2.0
        
        if directions.count == 2 {
            walkingSpeed = walkingSpeed / sqrt(2.0)
        }
        
        // choose direction of the sprites and move the sprite
        if directions.index(of: .up) != nil {
            self.position.y += walkingSpeed
            if currentDirection == nil || directions.count == 1 {
                currentDirection = .up
            }
        }
        if directions.index(of: .left) != nil {
            self.position.x -= walkingSpeed
            if currentDirection == nil || directions.count == 1 {
                currentDirection = .left
            }
        }
        if directions.index(of: .down) != nil {
            self.position.y -= walkingSpeed
            if currentDirection == nil || directions.count == 1 {
                currentDirection = .down
            }
        }
        if directions.index(of: .right) != nil {
            self.position.x += walkingSpeed
            if currentDirection == nil || directions.count == 1 {
                currentDirection = .right
            }
        }
        
        if currentDirection != nil {
            lastDirection = currentDirection
        }
        
        if !directions.isEmpty && self.currentDirection != nil {
            switch currentDirection! {
            case .up:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_up_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_up_1")
                }
            case .left:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_left_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_left_1")
                }
            case .down:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_down_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_down_1")
                }
            case .right:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_right_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_right_1")
                }
            }
        }
        else {
            currentDirection = nil
        }
        
        tick += 1
        if tick > 60 {
            tick = 0
        }
    }
        
    
    
    // the walk animation from the stylus
    func walkTowards(_ destination: CGPoint) {
        // if the finger is too close to the current position, nothing happens
        if abs(destination.x - self.frame.midX) < 4 && abs(destination.y - self.frame.midY) < 4 {
            return
        }
        
        let direction = CGPoint(
            x: destination.x - self.frame.midX,
            y: destination.y - self.frame.midY
        )
        let normalizedDirection = CGPoint(
            x: direction.x / (sqrt(direction.x ** 2 + direction.y ** 2)),
            y: direction.y / (sqrt(direction.x ** 2 + direction.y ** 2))
        )
        
        
        if direction.x > 0 && direction.y > 0 {
            if direction.x > direction.y {
                currentDirection = .right
            }
            else {
                currentDirection = .up
            }
        }
        else if direction.x < 0 && direction.y > 0 {
            if -direction.x > direction.y {
                currentDirection = .left
            }
            else {
                currentDirection = .up
            }
        }
        else if direction.x > 0 && direction.y < 0 {
            if direction.x > -direction.y {
                currentDirection = .right
            }
            else {
                currentDirection = .down
            }
        }
        else if direction.x < 0 && direction.y < 0 {
            if -direction.x > -direction.y {
                currentDirection = .left
            }
            else {
                currentDirection = .down
            }
        }
        
        if currentDirection != nil {
            lastDirection = currentDirection
        }
        
        self.position.x += normalizedDirection.x * walkingSpeed
        self.position.y += normalizedDirection.y * walkingSpeed
        
        if self.currentDirection != nil {
            switch currentDirection! {
            case .up:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_up_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_up_1")
                }
            case .left:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_left_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_left_1")
                }
            case .down:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_down_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_down_1")
                }
            case .right:
                if tick % 8 < 4 {
                    self.texture = sprites.textureNamed("hero_walk_right_0")
                }
                else {
                    self.texture = sprites.textureNamed("hero_walk_right_1")
                }
            }
 
        }
        else {
            currentDirection = nil
        }
        
        tick += 1
        if tick > 60 {
            tick = 0
        }


    }

    func moveByX(_ x: CGFloat, y: CGFloat) {
        var nextPosition = self.position
        nextPosition.x += x
        nextPosition.y += y
        self.position = nextPosition
    }
}
