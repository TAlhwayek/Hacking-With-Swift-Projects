//
//  ViewController.swift
//  Psychic Tester
//
//  Created by Tony Alhwayek on 8/24/23.
//

import UIKit

var allCards = [CardViewController]()

class ViewController: UIViewController {

    @IBOutlet var cardContainer: UIView!
    
    @IBOutlet var gradientView: GradientView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
  
    
    

}

