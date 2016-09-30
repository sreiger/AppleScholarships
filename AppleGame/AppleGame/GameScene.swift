//
//  GameScene.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-20.
//  Copyright (c) 2016 Shaun Reiger. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 32
}

/*struct Collision {
    static let player : UInt32 = 0x1 << 0
    static let wall : UInt32 = 0x1 << 1
}
*/


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //let sprites = SKTextureAtlas(named: "sprites")
    
    var hero: Player!
    var controller: ControllerNode!
    
    // ---- Collision Constants 
    let PlayerCategory      : UInt32 = 0x1 << 0 // 00000000000000000000000000000001
    let WallCategory        : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
    let StarCategory        : UInt32 = 0x1 << 2 // 00000000000000000000000000000100
    let VortexCategory      : UInt32 = 0x1 << 3 // 00000000000000000000000000001000
    let TrophyCategory      : UInt32 = 0x1 << 4 // 00000000000000000000000000010000
    
    // -------- Environment Constants
    //let blockNode = SKSpriteNode(imageNamed: "block2")
    //let vortexNode = SKSpriteNode(imageNamed: "vortex")
    //let starNode = SKSpriteNode(imageNamed: "star")


   
    
    
    override func didMove(to view: SKView) {
        
        // This method tells the physics world to call a method on your class when to bodies collide
        self.physicsWorld.contactDelegate = self
        
        hero = Player(named: "hero_walk_right_0")
        hero.name = "player"
        
        //-------Hero physics properties
        
        //let square = CGSize(width: hero.size.width, height: hero.size.height)
        //hero.physicsBody = SKPhysicsBody(rectangleOfSize: hero.size)
        
        //hero.physicsBody?.dynamic = false
        hero.physicsBody = SKPhysicsBody(rectangleOf: (hero.frame.size))  //SKPhysicsBody(circleOfRadius: hero.size.width/2)
        //hero.physicsBody!.friction = 0
       // hero.physicsBody!.restitution = 1
        //hero.physicsBody!.linearDamping = 0
        //hero.physicsBody!.angularDamping = 0
        hero.physicsBody!.isDynamic = true
        
        hero.physicsBody!.affectedByGravity = false
        hero.physicsBody!.allowsRotation = false
        
        
       // physicsBody?.categoryBitMask = WallCategory //CollisionTypes.Wall.rawValue
        
        hero.physicsBody!.categoryBitMask = PlayerCategory
        hero.physicsBody!.contactTestBitMask = WallCategory
        hero.physicsBody!.collisionBitMask = WallCategory|PlayerCategory
        hero.physicsBody!.usesPreciseCollisionDetection = true
        
        //----------------------
        
        
        hero.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(hero)
        self.loadLevel()
        
        if Settings.sharedInstance.virtualPad == true {
            controller = ControllerNode(position: CGPoint(x:0, y:0))
            self.addChild(controller)
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            

            
            let location = touch.location(in: self)
            
            if Settings.sharedInstance.virtualPad == false {
                hero.destination = location
            }
        }
    }
   
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
  
            if Settings.sharedInstance.virtualPad == false {
                hero.destination = location
            }
        }
            
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if Settings.sharedInstance.virtualPad == false {
            hero.destination = nil
        }
     }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if Settings.sharedInstance.virtualPad == false {
            hero.destination = nil
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if Settings.sharedInstance.virtualPad {
            hero.walk(self.controller!.pressedDirections())
        }
        else {
            if hero.destination != nil {
                hero.walkTowards(hero.destination!)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // this gets called automaticlly when two objects begin contact with each other
    /*
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        NSLog("HELLO")
        if contact.bodyB.categoryBitMask < contact.bodyA.categoryBitMask {
            NSLog("Entered phase 1")
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            NSLog("Entered phase 2")
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == WallCategory && secondBody.categoryBitMask == PlayerCategory {
            NSLog("Hit wall. First contact has been made.")
        }
 */
        
    }
    
    func collisionWall(_ Main: SKSpriteNode, Brick: SKSpriteNode) {
        
        //Player.physicsBody?.dynamic = true
        //Player.physicsBody?.affectedByGravity = true
       // Player.physicsBody?.mass = 5.0
       // Wall.physicsBody!.mass = 5.0
        //Player.removeAllActions()
       // Wall.removeAllActions()
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        // this gets called automaticlly when two objects end contact with each other
    }
    
    //---------Adding to make work
    
    func loadLevel() {
        
        if let levelPath = Bundle.main.path(forResource: "level1", ofType: "txt") {
            if let levelString = try? String(contentsOfFile: levelPath, usedEncoding: nil) {
                let lines = levelString.components(separatedBy: "\n")
                
                for (row, line) in lines.reversed().enumerated() {
                    for (column, letter) in line.characters.enumerated() {
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                        
                        if letter == "x" {
                            // load wall
                            let block = SKSpriteNode(imageNamed: "block2") 
                            //var xCenter = (block.size.width*(0.5) + block.size.width)
                            //var yCenter = (block.size.height*(0.5) + block.size.height)
//var zPoint = sqrt(xCenter**2 + yCenter**2) as CGPoint
                            block.name = "block" //+ String(column)
                            block.position = position
                            //print(block.frame.size)
                            //print(block.size)
                            
                            //print(block.centerRect.offsetBy(dx: -0.5, dy: -0.5))
                            //block.centerRect.offsetInPlace(dx: -0.5, dy: -0.5)
                           // block.
                            block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)//,
                                                              //center: position)
                            //block.physicsBody?.contactTestBitMask = PlayerCategory //CollisionTypes.Player.rawValue
                            //block.physicsBody?.collisionBitMask = 0
                            //block.physicsBody?.dynamic = false
                            block.physicsBody!.friction = 0.2
                            block.physicsBody!.affectedByGravity = false
                            block.physicsBody!.allowsRotation = false
                            block.setScale(1.2)
                            
                            block.physicsBody!.categoryBitMask = WallCategory//CollisionTypes.Wall.rawValue
                            block.physicsBody!.collisionBitMask = PlayerCategory|WallCategory
                            block.physicsBody!.contactTestBitMask = PlayerCategory
                            block.physicsBody!.usesPreciseCollisionDetection = true
                            block.physicsBody!.isDynamic = false

                            addChild(block)
                        } else if letter == "v"  {
                            // load vortex
                            let vortex = SKSpriteNode(imageNamed: "vortex")
                            vortex.name = "vortex"
                            vortex.position = position
                            vortex.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
                            vortex.physicsBody = SKPhysicsBody(circleOfRadius: vortex.size.width / 2)
                            vortex.physicsBody!.isDynamic = false
                            
                            //node.physicsBody!.categoryBitMask = CollisionTypes.Vortex.rawValue
                            //node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            //node.physicsBody!.collisionBitMask = 0
                            vortex.setScale(0.02)
                            addChild(vortex)
                            
                        } else if letter == "s"  {
                            // load star
                            let star = SKSpriteNode(imageNamed: "star")
                            star.name = "star"
                            star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width / 2)
                            star.physicsBody!.isDynamic = false
                            
                            //star.physicsBody!.categoryBitMask = CollisionTypes.Star.rawValue
                            //star.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            //star.physicsBody!.collisionBitMask = 0
                            star.setScale(1.2)
                            //star.position = position
                            addChild(star)
                        } else if letter == "f"  {
                            // load finish
                            let trophy = SKSpriteNode(imageNamed: "finish")
                            trophy.name = "finish"
                            trophy.physicsBody = SKPhysicsBody(circleOfRadius: trophy.size.width / 2)
                            trophy.physicsBody!.isDynamic = false
                            
                            //trophy.physicsBody!.categoryBitMask = CollisionTypes.Finish.rawValue
                            //trophy.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
                            //trophy.physicsBody!.collisionBitMask = 0
                            trophy.setScale(1.2)
                            //trophy.position = position
                            addChild(trophy)
                        }
                    }
                }
            }
        }
    }

    
    
    
    
}
