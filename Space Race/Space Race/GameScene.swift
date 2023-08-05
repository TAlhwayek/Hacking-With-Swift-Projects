//
//  GameScene.swift
//  Space Race
//
//  Created by Tony Alhwayek on 8/4/23.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate{
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["wall", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        // Create background
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        // Move 10 seconds worth of particles
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        // Create player
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        // Create score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
     
        score = 0
        
        // Disable gravity
        physicsWorld.gravity = .zero
        // Get contact
        physicsWorld.contactDelegate = self
        
        // Configure timer between objects spawning
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        // Get random enemy
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        // Allow collisions with player
        sprite.physicsBody?.categoryBitMask = 1
        // Make it move quickly on the x-axis (horizontally)
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        // Make it rotate
        sprite.physicsBody?.angularVelocity = 5
        // Does not slow down over time
        sprite.physicsBody?.linearDamping = 0
        // Never stop spinning
        sprite.physicsBody?.angularDamping = 0
    }
    
    // Remove junk when it goes off screen
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        // When that happens, increment score
        if !isGameOver {
            score += 1
        }
    }
}
