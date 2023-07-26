//
//  GameScene.swift
//  Pachinko
//
//  Created by Tony Alhwayek on 7/25/23.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Add background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        // Ignore alpha values for nodes
        background.blendMode = .replace
        // Place background behind everything else
        background.zPosition = -1
        addChild(background)
        
        // Add physics to the entire scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get first touch
        guard let touch = touches.first else { return }
        // Find location of touch
        let location = touch.location(in: self)
        
        // Create new ball at touch location
        let ball = SKSpriteNode(imageNamed: "ballRed")
        // Add physics to ball with radius
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        // Change 'bounciness' (max is 1)
        ball.physicsBody?.restitution = 0.4
        ball.position = location
        addChild(ball)
    }
    
    // Function to add bouncers
    func makeBouncer(at position: CGPoint) {
        // Add something for the ball to bounce on
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // Make bouncer immovable
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
}
