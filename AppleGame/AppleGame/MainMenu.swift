//
//  MainMenu.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-30.
//  Copyright © 2016 Shaun Reiger. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("Inside touchesBegan")
        let game : GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .aspectFit
        let transition : SKTransition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
        
        self.view?.presentScene(game, transition: transition)
    }
    
}
