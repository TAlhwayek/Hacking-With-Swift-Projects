//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Tony Alhwayek on 7/15/23.
//

import UIKit

class ViewController: UIViewController {

    // Button outlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // Score label
    @IBOutlet var scoreLabel: UILabel!
    
    // Variables
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    // Challenge variables
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Append country names to countries array
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // Add border to fix visibility issue with flags that contain white sections
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // Make borders touch the images
        button1.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button2.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button3.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // Change border colors to light gray
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        // Start the game
        askQuestion()
    }


    func askQuestion(action: UIAlertAction! = nil) {
        // Shuffle countries array to get random flags
        countries.shuffle()
        
        correctAnswer = Int.random(in: 0...2)
        
        // Populate images with randomly selected countries
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        

        // Use flag to guess as title
        title = countries[correctAnswer].uppercased()
        
        // Update scoreLabel to show country to guess
        scoreLabel.text = "Score: \(score)"
    }
    
    // Determine whether answer is right or wrong when flag is tapped
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        questionsAsked += 1
        
        // Check if game should end
        if questionsAsked == 10 {
            // Present final alert and reset score
            let ac = UIAlertController(title: "You have reached 10 questions", message: "Your final score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Retry?", style: .default, handler: nil))
            present(ac, animated: true)
            score = 0
            questionsAsked = 0
        } else {
            // Create alert to be displayed after each round
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
}

