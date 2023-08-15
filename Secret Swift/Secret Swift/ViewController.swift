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
    
    // For challenge #2
    // Allow user to set password on first login
    var passwordSet = false
    
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
        
        authenticateUser()
        
    }
    
    // Authentication methods
    // When authenticate button is tapped
    @IBAction func authenticateTapped(_ sender: Any) {
        authenticateUser()
    }
    
    // Added my own function to unlock the app when it is opened.
    // The authenticate button is still there for when the user manually locks the app.
    func authenticateUser() {
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
                        // Only ask for password if password was set
                        if self?.passwordSet == true {
                            self?.usePassword()
                        }
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
    
    // Message saving and loading
    // Unlock the message
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff"
        // Load text using keychain
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        // Challenge #1
        // Add a button that locks the app
        // Only visible when app is unlocked
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
        // Self-challenge
        // Allow user to change password
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit password", style: .plain, target: self, action: #selector(changePassword))
        enrollUserPassword()
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
    
    // Challenge #2
    // Use password as fallback for biometrics
    func usePassword() {
        let passwordAC = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
        passwordAC.addTextField { textField in
            // Make text field secure
            textField.isSecureTextEntry = true
        }
        
        let authenticationAction = UIAlertAction(title: "Authenticate", style: .default) { [weak self, weak passwordAC] _ in
            // Get text from textfield
            guard let password = passwordAC?.textFields?[0].text else { return }
            self?.submit(password)
        }
        passwordAC.addAction(authenticationAction)
        present(passwordAC, animated: true)
    }
    
    // Submit password
    // Used in usePassword()
    func submit(_ password: String) {
        if password == KeychainWrapper.standard.string(forKey: "Password") {
            unlockSecretMessage()
        } else {
            let ac = UIAlertController(title: "Incorrect password", message: "Please try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // Enrolling user's password
    // Should only be presented once
    func enrollUserPassword() {
        print("ASKING FOR PASSWORD")
        if !passwordSet {
            print("NO PASSWORD SET")
            let passwordAC = UIAlertController(title: "Set a password", message: "A password is used in case you cannot authenticate using your biometric sensor.", preferredStyle: .alert)
            passwordAC.addTextField()
            
            let submitAction = UIAlertAction(title: "Save password", style: .default) { [weak self, weak passwordAC] _ in
                // Get text from textfield
                guard let password = passwordAC?.textFields?[0].text else { return }
                // Make sure password isn't blank
                if password.count == 0 {
                    let ac = UIAlertController(title: "Password cannot be blank", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        // Show prompt again
                        self?.enrollUserPassword()
                    }
                    ac.addAction(okAction)
                    self?.present(ac, animated: true)
                } else {
                    // Set password
                    KeychainWrapper.standard.set(password, forKey: "Password")
                    self?.passwordSet = true
                }
                
            }
            passwordAC.addAction(submitAction)
            present(passwordAC, animated: true)
            
        }
    }
    
    // For self-challenge
    // Allows the user to change password
    @objc func changePassword() {
        let passwordAC = UIAlertController(title: "Change your password", message: nil, preferredStyle: .alert)
        passwordAC.addTextField()
        
        let submitAction = UIAlertAction(title: "Save password", style: .default) { [weak passwordAC] _ in
            // Get text from textfield
            guard let password = passwordAC?.textFields?[0].text else { return }
            // Make sure password isn't blank
            if password.count == 0 {
                let ac = UIAlertController(title: "Password cannot be blank", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                    // Show prompt again
                    self?.changePassword()
                }
                ac.addAction(okAction)
                self.present(ac, animated: true)
            } else {
                // Change password
                KeychainWrapper.standard.set(password, forKey: "Password")
            }
        }
        passwordAC.addAction(submitAction)
        passwordAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(passwordAC, animated: true)
    }
    
    // Keyboard fixing
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
}

