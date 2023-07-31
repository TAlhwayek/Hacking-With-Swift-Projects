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
        
        // Challenge #3
        // Add a left-side nav bar button that restarts the game
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        // Get words from provided text file
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        // Load previous game
        let defaults = UserDefaults.standard
        
        if let savedUsedWords = defaults.data(forKey: "usedWords") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                // Load saved used words
                usedWords = try jsonDecoder.decode([String].self, from: savedUsedWords)
            } catch {
                print("Error loading data: \(error)")
            }
        }
        
        loadTitle()
        
        
        // If no words were read in (i.e an error occurred)
        if allWords.isEmpty {
            allWords = ["NO WORDS WERE FOUND"]
        }
        
        // Start the game
        // startGame()
    }

    @objc func startGame() {
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
            // Save title for challenge #3 of project 12
            self?.saveTitle()
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
        
        // Check word
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if longerThanThreeLetters(word: lowerAnswer) {
                        if isGivenWord(word: lowerAnswer){
                            // Add word to usedWords[0]
                            usedWords.insert(lowerAnswer, at: 0)
                            saveWords()
                            
                            // Insert new row at [0, 0]
                            let indexPath = IndexPath(row: 0, section: 0)
                            // Add new row with animation
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            
                            // Return to avoid showing alert controller
                            return
                        } else {
                            showErrorMessage(errorTitle: "You are using the given word", errorMessage: "Don't do that")
                        }
                    } else {
                        showErrorMessage(errorTitle: "Your word is shorter than 3 letters", errorMessage: "Please use a longer word")
                    }
                } else {
                    showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up")
                }
            } else {
                showErrorMessage(errorTitle: "Word already used", errorMessage: "Be more original")
            }
        } else {
            guard let title = title else { return }
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "Word cannot be spelled using \(title.lowercased())")
        }
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
    
    // For challenge #1
    // Disallows word if it's shorter than 3 letters
    func longerThanThreeLetters(word: String) -> Bool {
        if word.count >= 3 {
            return true
        } else {
            return false
        }
    }
    // Also for challenge #1
    func isGivenWord(word: String) -> Bool {
        if word != title {
            return true
        } else {
            return false
        }
    }
    
    // For challenge #2
    // Handle error alert
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        // Show error to user using an alert controller
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func saveWords() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        // Save used words list
        do {
            let savedUsedWords = try jsonEncoder.encode(usedWords)
            defaults.set(savedUsedWords, forKey: "usedWords")
        } catch {
            print("Error savings used words: \(error)")
        }
    }
    
    // For project 12 - challenge #3
    // Save and load title
    func saveTitle() {
        let defaults = UserDefaults.standard
        defaults.set(title, forKey: "title")
    }
    
    func loadTitle() {
        let defaults = UserDefaults.standard
        if let savedTitle = defaults.string(forKey: "title") {
            title = savedTitle
        }
    }
}

