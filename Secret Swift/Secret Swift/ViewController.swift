//
//  ViewController.swift
//  Secret Swift
//
//  Created by Tony Alhwayek on 8/13/23.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Secret title that keeps nosey people away 👀
        title = "Nothing to see here"
        
        // Handle screen moving with keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // Save secret message when user leaves the app
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        // Obj-C form of an error
        var error: NSError!
        
        // If we can use biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                // Force biometric to use main thread
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // Present alert if could not verify
                        // let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified. Please try again.", preferredStyle: .alert)
                        // ac.addAction(UIAlertAction(title: "OK", style: .default))
                        // self?.present(ac, animated: true)
                        self?.usePassword()
                    }
                }
            }
        } else {
            // No biometric sensors available
            let ac = UIAlertController(title: "Biometric sensor unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    // Unlock the message
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff"
        // Load text using keychain
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        // Challenge #1
        // Add a button that locks the app
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
    }
    
    // Save the message
    @objc func saveSecretMessage() {
        // Make sure that secret is visible
        guard secret.isHidden == false else { return }
        
        // Save using keychain
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        // Hide text editor
        secret.resignFirstResponder()
        // Hide text
        secret.isHidden = true
        // Set title back to what it was
        title = "Nothing to see here"
        
        // Remove right bar button when app is locked
        navigationItem.rightBarButtonItem = nil
    }
    
    // Func that fixes keyboard issues when dealing with text
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // Get size of keyboard relative to screen
        let keyboardScreenEnd = keyboardValue.cgRectValue
        // Account for rotated screen
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    // Challenge #2
    // Use password as fallback for biometrics
    func usePassword() {
        let passwordAC = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
        passwordAC.addTextField()
        
        let authenticationAction = UIAlertAction(title: "Authenticate", style: .default) { [weak self, weak passwordAC] _ in
            // Get text from textfield
            guard let password = passwordAC?.textFields?[0].text else { return }
            self?.submit(password)
        }
        passwordAC.addAction(authenticationAction)
        present(passwordAC, animated: true)
    }
    
    func submit(_ password: String) {
        if password == KeychainWrapper.standard.string(forKey: "Password") {
            unlockSecretMessage()
        } else {
            let ac = UIAlertController(title: "Incorrect password", message: "Please try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

// TODO:
// Need to add a way to add a password
// Also fix textfield to show "password" characters (those black circles)

