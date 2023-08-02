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
        
    }
    
    // Create new slot at specified position and add to slots array
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
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
