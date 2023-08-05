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
    // For challenge #2
    // Count the number of enemies to modify the timer accordingly
    var enemiesCreated = 0
    // Start timer at 1 second
    var dynamicTimer = 1.0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        print("GAME STARTED")
        
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
        gameTimer = Timer.scheduledTimer(timeInterval: dynamicTimer, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    // Create random enemy
    @objc func createEnemy() {
        // Challenge #3
        // Stop creating space debris after game over
        if !isGameOver {
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
            
            // For challenge #2
            // Count created enemies
            enemiesCreated += 1
            print(enemiesCreated)
            
            // Reduce timer by 0.1 seconds after 20, 40, 60, etc. enemies are spawned
            if enemiesCreated > 0 && enemiesCreated % 20 == 0 {
                // Make sure we don't hit 0
                if dynamicTimer > 0.1 {
                    // Decrease time between spawns
                    dynamicTimer -= 0.1
                    // Delete old timer and start new one with reduced interval
                    gameTimer?.invalidate()
                    gameTimer = Timer.scheduledTimer(timeInterval: dynamicTimer, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
                }
            }
        }
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
    
    // When a touch is detected
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get first touch and its location
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        // Create bounds for player
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        // Allow player to move where user touched
        player.position = location
    }
    
    // Challenge #1
    // End the game if the player removes their finger, as it is considered cheating
    // I added the labels on my own because it gives the user an idea of what happened
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            isGameOver = true
            
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.fontSize = 48
            gameOverLabel.position = CGPoint(x: 512, y: 384)
            addChild(gameOverLabel)
            
            let gameOverSubtitle = SKLabelNode(fontNamed: "Chalkduster")
            gameOverSubtitle.text = "Removing your finger is considered as cheating!"
            gameOverSubtitle.fontSize = 36
            gameOverSubtitle.position = CGPoint(x: 512, y: 300)
            addChild(gameOverSubtitle)
        }
    }
    
    // On contact with object
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        // Remove player
        player.removeFromParent()
        // End game
        isGameOver = true
    }
}
