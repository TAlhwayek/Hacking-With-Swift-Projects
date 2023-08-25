//
//  ViewController.swift
//  Psychic Tester
//
//  Created by Tony Alhwayek on 8/24/23.
//

import AVFoundation
import UIKit

var allCards = [CardViewController]()

class ViewController: UIViewController {
    
    @IBOutlet var cardContainer: UIView!
    
    @IBOutlet var gradientView: GradientView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createParticles()
        loadCards()
        
        view.backgroundColor = .red
        
        UIView.animate(withDuration: 20, delay: 0, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
            self.view.backgroundColor = .blue
        })
    }
    
    @objc func loadCards() {
        // Remove previous cards
        for card in allCards {
            card.view.removeFromSuperview()
            card.removeFromParent()
        }
        
        allCards.removeAll(keepingCapacity: true)
        
        view.isUserInteractionEnabled = true
        
        // Create an array of card positions
        let positions = [
            CGPoint(x: 75, y: 85),
            CGPoint(x: 185, y: 85),
            CGPoint(x: 295, y: 85),
            CGPoint(x: 405, y: 85),
            CGPoint(x: 75, y: 235),
            CGPoint(x: 185, y: 235),
            CGPoint(x: 295, y: 235),
            CGPoint(x: 405, y: 235)
        ]
        
        // Load and unwrap card images
        let circle = UIImage(named: "cardCircle")!
        let cross = UIImage(named: "cardCross")!
        let lines = UIImage(named: "cardLines")!
        let square = UIImage(named: "cardSquare")!
        let star = UIImage(named: "cardStar")!
        
        // Create an array of the images, one for each card, then shuffle
        var images = [circle, circle, cross, cross, lines, lines, square, square, star, star]
        images.shuffle()
        
        for (index, position) in positions.enumerated() {
            // Loop over each card and create a new vc
            let card = CardViewController()
            card.delegate = self
            
            // Add card to view
            addChild(card)
            cardContainer.addSubview(card.view)
            card.didMove(toParent: self)
            
            // Give card image
            // Then position it
            card.view.center = position
            card.front.image = images[index]
            
            // If card is given a star image, mark it as correct
            if card.front.image == star {
                card.isCorrect = true
            }
            
            // Add card to array
            allCards.append(card)
        }
    }
    
    func cardTapped(_ tapped: CardViewController) {
        guard view.isUserInteractionEnabled == true else { return }
        view.isUserInteractionEnabled = false
        
        for card in allCards {
            if card == tapped {
                card.wasTapped()
                card.perform(#selector(card.wasntTapped), with: nil, afterDelay: 1)
            } else {
                card.wasntTapped()
            }
        }
        
        perform(#selector(loadCards), with: nil, afterDelay: 2)
    }
    
    /*
     The birthRate property sets how many particles to create every second.
     The lifetime property sets how long each particle should live, in seconds.
     The velocity property sets the base movement speed for each particle.
     The velocityRange property sets how much velocity variation there can be.
     The emissionLongitude property sets the direction particles are fired.
     The spinRange property sets how much spin variation there can be between particles.
     The scale property sets how large particles should be, where 1.0 is full size.
     The scaleRange property sets how much size variation there can be between particles.
     The color property sets the color to be applied to each particle.
     The alphaSpeed property sets how fast particles should be faded out (or in) over their lifetime.
     The contents property assigns a CGImage to be used as the image.
     */
    func createParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.frame.width / 2.0, y: -50)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.width, height: 1)
        particleEmitter.renderMode = .additive
        
        let cell = CAEmitterCell()
        cell.birthRate = 2
        cell.lifetime = 5
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.spinRange = 5
        cell.scale = 0.5
        cell.scale = 0.25
        cell.color = UIColor(white: 1, alpha: 0.1).cgColor
        cell.alphaSpeed = -0.025
        cell.contents = UIImage(named: "particle")?.cgImage
        particleEmitter.emitterCells = [cell]
        gradientView.layer.addSublayer(particleEmitter)
    }
    
    
    
    
}

