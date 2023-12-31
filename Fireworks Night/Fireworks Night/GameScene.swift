//
//  GameScene.swift
//  Fireworks Night
//
//  Created by Tony Alhwayek on 8/7/23.
//

import SpriteKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLabel = SKLabelNode()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    // For challenge #2
    // Count number of launches
    var launches = 0

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 32
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: 100, y: 20)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
    
        // Start game timer
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)

    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        // Allow us to color the firework
        // colorBlendFactor make the sprite take on the full color (if it was 0.5, it would be half red and half white)
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }

        // Draw path of rockets
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // Follow the path
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        // Add sparks behind rockets
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // Fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            // Fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: +100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: +200, x: 512 + 200, y: bottomEdge)
        case 2:
            // Fire five, from left to right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
        case 3:
            // Fire five, from right to left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            
        default:
            break
        }
        
        // Count number of launches
        launches += 1
        
        // End game after 10 launches
        if launches >= 10 {
            gameTimer?.invalidate()
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        // Get location of touch
        let location = touch.location(in: self)
        // Get nodes at touch point
        let nodesAtPoint = nodes(at: location)
        
        // Create node only if condition is true
        // Guarantees that we hve a sprite node
        for case let node as SKSpriteNode in nodesAtPoint {
            // Make sure we tapped a firework
            guard node.name == "firework" else { continue }
            
            
            for parent in fireworks {
                // Exit the loop if we can't find the sprite node in the parent node
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                // If currently selected and not equal to new node color
                if firework.name == "selected" && firework.color != node.color {
                    // Reset changes
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            // Set rocket color back to white
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    // If firework left the screen, destroy it
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        let wait = SKAction.wait(forDuration: 2)
        
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            // Create explosion at position of firework
            emitter.position = firework.position
            addChild(emitter)
            // Challenge #3
            let sequence = SKAction.sequence([
                SKAction.wait(forDuration: 0.5),
                SKAction.removeFromParent()
            ])
            emitter.run(sequence)
        }
        // Remove firework from game scene
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        // Count number of explosions
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        case 5:
            score += 4000
        default:
            break
        }
    }
    
    
    
}
