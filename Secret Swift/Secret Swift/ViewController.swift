//
//  ViewController.swift
//  Secret Swift
//
//  Created by Tony Alhwayek on 8/13/23.
//

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
        unlockSecretMessage()
    }
    
    // Unlock the message
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff"
        // Load text using keychain
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
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
    
}

