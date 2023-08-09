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
    
    // Store words
    var words = [String]()
    // Array to store used letters
    var usedLetters = [String]()
    // Count wrong answers
    var wrongAnswerCount = 0
    

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
        
        print("PRINTING WORDS")
  //      for word in words {
            print(words)
    //    }
    }

    // Function that gets a new word from the list and starts a new game
    @objc func newGame() {
        // Clear used letters
        usedLetters.removeAll()
    }
    
    // Let user add letter
    @objc func addLetter() {
        // Present an alert controller so user can enter a letter
        let wordAC = UIAlertController(title: "Enter letter", message: nil, preferredStyle: .alert)
        // Add a text field
        wordAC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak wordAC] _ in
            // Get letter
            guard let submittedLetter = wordAC?.textFields?[0].text else { return }
            print(submittedLetter)
            // Submit letter
            // self?.submit(submittedLetter)
        }
        
        wordAC.addAction(submitAction)
        present(wordAC, animated: true)
    }
    
    func checkCharacterCount() {
        
    }
    
    // Show an alert controller when needed
    func showErrorAC(title: String, message: String) {
        let errorAC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        errorAC.addAction(okAction)
        present(errorAC, animated: true)
    }
}

