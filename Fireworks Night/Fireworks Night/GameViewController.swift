//
//  GameViewController.swift
//  Fireworks Night
//
//  Created by Tony Alhwayek on 8/7/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Explode all fireworks when device is shaken
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard let skView = view as? SKView else { return }
        
        guard let gameScene = skView.scene as? GameScene else { return }
        
        gameScene.explodeFireworks()
    }
}
