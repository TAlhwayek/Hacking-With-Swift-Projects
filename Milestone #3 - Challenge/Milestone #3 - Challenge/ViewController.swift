//
//  ViewController.swift
//  Milestone #3 - Challenge
//
//  Created by Tony Alhwayek on 8/8/23.
//

import UIKit

class ViewController: UIViewController {
    
    // Label that displays current word and progress
    @IBOutlet var wordTitle: UILabel!
    // Display how many lives the user still has
    @IBOutlet var livesRemainingLabel: UILabel!
    // Store words
    var words = [String]()
    // Array to store used letters
    var usedLetters = [String]()
    // Count wrong answers
    var wrongAnswerCount = 0
    
    // Change color of livesRemainingLabel based on lives left
    var colors = [".red", ".red", ".orange", ".yellow", ".yellow", ".green", ".green"]
    // Define a mapping between color strings and UIColors
    let colorMapping: [String: UIColor] = [
        ".red": UIColor.red,
        ".orange": UIColor.orange,
        ".yellow": UIColor.yellow,
        ".green": UIColor.green
    ]
    // How many lives the user still has
    var livesRemaining = 2 {
        didSet {
            livesRemainingLabel.text = "Lives remaining: \(livesRemaining)"
            let colorString = colors[livesRemaining - 1]
            if let color = colorMapping[colorString] {
                livesRemainingLabel.textColor = color
            }
        }
    }
    
    // Current word to guess
    var currentWord: String = ""
    // The word, but hidden
    var hiddenWord: String = "" {
        didSet {
            wordTitle.text = "\(hiddenWord)"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Right button lets user enter letter
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLetter))
        // Left button lets user start a new level
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newGame))
        
        // Get words from text file
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsFromFile = try? String(contentsOf: wordsURL) {
                // Get all words from document and ignore blank lines
                words = wordsFromFile.components(separatedBy: "\n").filter { !$0.isEmpty }
            }
        }
        
        title = "Hang the Dead Man"
        
        newGame()
    }

    // Function that gets a new word from the list and starts a new game
    @objc func newGame() {
        // Clear used letters
        usedLetters.removeAll()
        livesRemaining = 7
        // Get new word
        currentWord = words.randomElement()!
        // Initialize hidden word and use that in the game
        hiddenWord = String(repeating: "?", count: currentWord.count)
        
        // DEBUGGING REMEMBER TO REMOVE
        print(currentWord)
        print(hiddenWord)
    }
    
    // Let user add letter
    @objc func addLetter() {
        // Present an alert controller so user can enter a letter
        let wordAC = UIAlertController(title: "Enter letter", message: nil, preferredStyle: .alert)
        // Add a text field
        wordAC.addTextField()
        
        // When user submits an answer
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak wordAC] _ in
            // Get letter
            guard let submittedLetter = wordAC?.textFields?[0].text else { return }
            // Submit letter
            self?.submit(submittedLetter)
        }
        
        wordAC.addAction(submitAction)
        present(wordAC, animated: true)
    }
    
    // Make sure only one letter was submitted
    func checkCharacterCount(letter: String) -> Bool {
        return letter.count == 1
    }
    
    // Make sure user only submits letters
    func containsOnlyLetters(letter: String) -> Bool {
        let onlyAllowLetters = CharacterSet.letters
        return letter.unicodeScalars.allSatisfy { onlyAllowLetters.contains($0)}
    }
    
    func isUsedLetter(letter: String) -> Bool {
        return usedLetters.contains(letter)
    }
    
    // Check if the letter is part of the word
    func isACorrectLetter(letter: String) -> Bool {
        // Check if original word contains
        // Then replace position in hiddenWord
        
        if let index = currentWord.firstIndex(of: Character(letter)) {
            
        }
    }
    
    // Main submit functionality
    // Makes sure letter passes all checks
    func submit(_ letter: String) {
        // Check if only ONE character was submitted
        if checkCharacterCount(letter: letter) {
            // Check if input contains a letter and not a number, punctuation, etc.
            if containsOnlyLetters(letter: letter) {
                // Check if letter was not already used
                if !isUsedLetter(letter: letter) {
                    // Check if letter is part of the solution
                    if isACorrectLetter(letter: letter) {
                        
                    } else {
                        // Deduct a life for an incorrect answer
                        livesRemaining -= 1
                        
                        // Check if game over
                        if livesRemaining == 0 {
                            let gameOverAC = UIAlertController(title: "Game Over", message: "You ran out of lives", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Try again?", style: .default) { _ in
                                // Start new game
                                self.newGame()
                            }
                            gameOverAC.addAction(okAction)
                            present(gameOverAC, animated: true)
                        } else {
                            showErrorAC(title: "Wrong Answer", message: "")
                        }
                    }
                } else {
                    showErrorAC(title: "Letter already used", message: "Please use a different letter")
                }
            } else {
                showErrorAC(title: "Invalid input", message: "Please input a LETTER")
            }
        } else {
            showErrorAC(title: "Invalid input", message: "Please input only ONE letter")
        }
        
        
       
    }
    
    // Show an alert controller when needed
    func showErrorAC(title: String, message: String) {
        let errorAC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        errorAC.addAction(okAction)
        present(errorAC, animated: true)
    }
}

