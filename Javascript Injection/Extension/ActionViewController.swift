//
//  ActionViewController.swift
//  Extension
//
//  Created by Tony Alhwayek on 8/6/23.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    var selectedJavaScript: String!
    let alertSelected = "alert(document.title)"
    let alert42Selected = "alert(\"42\")"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bar button item to call done
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(listOpened))
        
        // New observers to make keyboard dynamic
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Get first item from array of data sent by parent app
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // Contains array of attachments
            // Pull out first attachment
            if let itemProvider = inputItem.attachments?.first {
                // Provide us with this item
                // Executres asynchronously because of closure
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // New dictionary to store requested values
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    // Get data using javascript
                    guard let javascriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javascriptValues["title"] as? String ?? ""
                    self?.pageURL = javascriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": selectedJavaScript ?? script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    // Let the keybaord keep up with scrolling text editor
    @objc func adjustForKeyboard(notification: Notification) {
        // Get size of keyboard
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        // Scroll to where user is typing
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    // Challenge #1
    @objc func listOpened() {
        let ac = UIAlertController(title: "Select a script to run", message: nil, preferredStyle: .alert)
        let siteAlert = UIAlertAction(title: "Alert", style: .default) { _ in
            self.selectedJavaScript = self.alertSelected
        }
    
        let alert42 = UIAlertAction(title: "Alert(\"42\")", style: .default) { _ in
            self.selectedJavaScript = self.alert42Selected
        }
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": self.selectedJavaScript]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(siteAlert)
        ac.addAction(alert42)
        ac.addAction(cancel)
        present(ac, animated: true)
    }

}
