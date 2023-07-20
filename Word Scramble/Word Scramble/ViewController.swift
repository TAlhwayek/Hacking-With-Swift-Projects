//
//  ViewController.swift
//  Word Scramble
//
//  Created by Tony Alhwayek on 7/19/23.
//

import UIKit

class ViewController: UITableViewController {
    
    // Arrays to store words
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Add a nav bar button for prompting the user
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        
        // Get words from provided text file
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        // If no words were read in (i.e an error occurred)
        if allWords.isEmpty {
            allWords = ["NO WORDS WERE FOUND"]
        }
        startGame()
    }

    func startGame() {
        // Set title as random word from the array
        title = allWords.randomElement()
        // Clean up used words array
        usedWords.removeAll(keepingCapacity: true)
        // Reload table
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        // Add a textfield for user input
        ac.addTextField()
        
        // Our first trailing closure
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        // Present alert
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    // Checks if:
    // 1) Word can be made from given letters
    // 2) Word has already been used
    // 3) Word is actually a valid english word
    // Then adds word to usedWords
    func submit (_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        // To show why the user's word is incorrect
        let errorTitle: String
        let errorMessage: String
        
        // If all checks pass
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    // Add word to usedWords[0]
                    usedWords.insert(answer, at: 0)
                    
                    // Insert new row at [0, 0]
                    let indexPath = IndexPath(row: 0, section: 0)
                    // Add new row with animation
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    // Return to avoid showing alert controller
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up"
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Be more original"
            }
        } else {
            guard let title = title else { return }
            errorTitle = "Word not possible"
            errorMessage = "Word cannot be spelled using \(title.lowercased())"
        }
        // Show error to user using an alert controller
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // Loop over all letters
    // Get position of first occurance of letter if it exists, else return false
    // Remove letter from tempWord
    // Loop
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    // Returns true if word has not been used
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        // Start at 0 and scan full word
        let range = NSRange(location: 0, length: word.utf16.count)
        // Check entire word in English
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // Return true if not misspelling was found
        // NSNotFound signifies that no misspelling was found
        return misspelledRange.location == NSNotFound
    }
}

