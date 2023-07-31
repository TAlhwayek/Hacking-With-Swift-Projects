//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Tony Alhwayek on 7/15/23.
//

import UIKit

class ViewController: UIViewController {

    // Button (flag) outlets
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // Score label
    @IBOutlet var scoreLabel: UILabel!
    
    // High score label
    @IBOutlet var highScoreLabel: UILabel!
    
    // Variables
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    // Use user defaults
    var highScore = 0 {
        didSet {
            // Update high score label whenever it changes
            highScoreLabel.text = "High score: \(highScore)"
        }
    }
    
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
        
        // Change border colors to light gray
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        // Load data
        let defaults = UserDefaults.standard

        if let savedHighScore = defaults.object(forKey: "highScore") as? Data {
          let jsonDecoder = JSONDecoder()

          do {
              // Load high score
              highScore = try jsonDecoder.decode(Int.self, from: savedHighScore)
          } catch {
            print("Error decoding the array: \(error)")
          }
        }
        
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
        
        button1.imageView?.contentMode = .scaleAspectFit
        button2.imageView?.contentMode = .scaleAspectFit
        button3.imageView?.contentMode = .scaleAspectFit
        
        // Use flag to guess as title
        title = countries[correctAnswer].uppercased()
        
        // Update scoreLabel to show country to guess
        scoreLabel.text = "Score: \(score)"
    }
    
    // Determine whether answer is right or wrong when flag is tapped
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String = ""
        var buttonTitle: String = "Continue"
        
        // Check if answer is correct
        // Also change the alert's title and message depending on the outcome
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            message = "Your score is \(score)"
        } else {
            title = "Incorrect"
            score -= 1
            message = "That's the flag of \(countries[sender.tag].uppercased())"
        }
        
        // Increment questions asked counter
        questionsAsked += 1
        
        // Check if game should end
        if questionsAsked == 10 {
            // Present the final alert and reset score
            message = "Your final score is \(score)"
            buttonTitle = "Play again?"
            
            // Working on project 12 - challenge #2
            if score > highScore {
                highScore = score
                
                // Save high score
                save()
                
                // Present alert
                let ac = UIAlertController(title: "New highscore!", message: "Your new highscore is \(score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play again?", style: .default))
                present(ac, animated: true)
            }
            
            score = 0
            questionsAsked = 0
        }
        
        // Present alert
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    // Save our highscore
    func save() {
         let defaults = UserDefaults.standard
         let jsonEncoder = JSONEncoder()

         do {
             let savedHighScore = try jsonEncoder.encode(highScore)
             defaults.set(savedHighScore, forKey: "highScore")
         } catch {
             print("Encoding error: \(error)")
         }
     }
}

