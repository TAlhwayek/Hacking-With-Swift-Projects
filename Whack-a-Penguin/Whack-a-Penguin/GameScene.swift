//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Tony Alhwayek on 7/31/23.
//

import SpriteKit

class GameScene: SKScene {
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    
    var popUpTime = 0.85
    // Number of rounds
    var numRounds = 0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        // Draw the whole background over original background
        background.blendMode = .replace
        // Place it behind everything
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        // Left align the text
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        // Create all slots
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        // Wait 1 second before creating first enemy
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get location of tap
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            // Try to read grandparent of tapped object
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            // Check if visible
            if !whackSlot.isVisible { continue }
            // Check if already hit
            if whackSlot.isHit { continue }
            // Trigger hit function
            whackSlot.hit()
            
            if node.name == "charFriend" {
                score -= 5
                // Play sound
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                // Shrink penguin
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                // Play sound
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    // Create new slot at specified position and add to slots array
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        // Increment round counter
        numRounds += 1
        
        // End game at 30 rounds
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            return
        }
        // Decrease time between penguins spawning
        popUpTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popUpTime)
        
        // Random chance to spawn multiple penguins
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popUpTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popUpTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popUpTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popUpTime) }
        
        // Min and max delay
        let minDelay = popUpTime / 2.0
        let maxDelay = popUpTime * 2.0
        // Randomize delay
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}
