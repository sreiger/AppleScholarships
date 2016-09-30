//
//  GameViewController.swift
//  AppleGame
//
//  Created by Shaun Reiger on 2016-04-20.
//  Copyright (c) 2016 Shaun Reiger. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed:"MainMenu") {
            
            // Configure the view.
            let skView = self.view as! SKView
            
            let scene = GameScene(size: CGSize(width: 1080, height: 1920))
            
            
            
           
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
    }
    
 

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
