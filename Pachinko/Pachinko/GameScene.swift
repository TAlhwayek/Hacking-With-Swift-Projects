//
//  GameScene.swift
//  Pachinko
//
//  Created by Tony Alhwayek on 7/25/23.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel = SKLabelNode()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // For allowing edit mode
    var editLabel = SKLabelNode()
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        // Add background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        // Ignore alpha values for nodes
        background.blendMode = .replace
        // Place background behind everything else
        background.zPosition = -1
        addChild(background)
        
        // Add score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        // Add edit label
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        // Add physics to the entire scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // Make our world it's own delegate (for collision notifications)
        physicsWorld.contactDelegate = self
        
        // Add slots
        makeSlots(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlots(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlots(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlots(at: CGPoint(x: 896, y: 0), isGood: false)
        
        // Add bouncers
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
        
        // Check if they tapped the edit button
        let objects = nodes(at: location)
        
        // Toggle value if button was tapped
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            // Check if in editing mode to allow user to add obstacles
            if editingMode {
                // Get random size
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                // Create box with random colors
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                // Rotate is randomly
                box.zRotation = CGFloat.random(in: 0...3)
                // Get location from touch
                box.position = location
                // Generate box size
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                // Make box immovable
                box.physicsBody?.isDynamic = false
                // Add box to view
                addChild(box)
            } else {
                // Create new ball at touch location
                let ball = SKSpriteNode(imageNamed: "ballRed")
                // Add physics to ball with radius
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                // Change 'bounciness' (max is 1)
                ball.physicsBody?.restitution = 0.4
                // Get collision information
                // "Tell us what you're bouncing off of"
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = CGPoint(x: location.x, y: 768)
                ball.name = "ball"
                addChild(ball)
            }
        }
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
    
    // Create slots for the balls
    func makeSlots(at position: CGPoint, isGood: Bool) {
        // Create new objects
        var slotBase = SKSpriteNode()
        var slotGlow = SKSpriteNode()
        
        // If green slot
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
            // If red slot
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        // Place nodes based on their passed in positions
        slotBase.position = position
        slotGlow.position = position
        
        // Add physics to slots
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        // Add nodes
        addChild(slotBase)
        addChild(slotGlow)
        
        // Let glow spin forever
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    // Func to handle collisions and update score
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    // Destroy ball
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // To avoid having crashes when ball was removed but triggers a collision
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        // If the first thing we collided with is called "ball"
        if contact.bodyA.node?.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if contact.bodyB.node?.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
