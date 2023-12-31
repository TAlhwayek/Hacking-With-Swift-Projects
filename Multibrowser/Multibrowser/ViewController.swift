//
//  ViewController.swift
//  Multibrowser
//
//  Created by Tony Alhwayek on 8/15/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        // Add two right bar button items
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [add, delete]
        
        // Center address bar text
        addressBar.textAlignment = .center
        // Always start with an open tab
        addWebView()
    }
    
    // Set a generic nav bar title
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    @objc func addWebView() {
        // Update title before the web page loads
        // Idk if I should use the main thread, but it wouldn't work without it
        DispatchQueue.main.async {
            self.title = "Loading..."
        }
            
        // Create new webview
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        // Casual self-plug
        let url = URL(string: "https://github.com/TAlhwayek")!
        // Load specified URL
        webView.load(URLRequest(url: url))
        
        // Highlight selected webView
        webView.layer.borderColor = UIColor.systemBlue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    // When user presses return, load new website
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Loading text appears before web page loads
        // When web page loads, title becomes title of web page
        title = "Loading..."
        
        if let webView = activeWebView, let address = addressBar.text {
            if var url = URL(string: address) {
                // Check if url is already complete
                if url.absoluteString.hasPrefix("https://www.") {
                    webView.load(URLRequest(url: url))
                } else {
                    // Else, complete the URL
                    url = URL(string: "https://www.\(address)")!
                }
                webView.load(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    // Highlight borders of selected webview
    func selectWebView(_ webView: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        activeWebView = webView
        webView.layer.borderWidth = 2
        
        // Updates title and text in address bar when a different webView is selected
        updateUI(for: webView)
    }
    
    // When a web view is tapped
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    // Recognize tapped webView
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Delete selected webView
    @objc func deleteWebView() {
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.firstIndex(of: webView) {
                // Remove and destroy webView (destroy = clear from memory)
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    setDefaultTitle()
                } else {
                    var currentIndex = Int(index)
                    
                    // Go back 1 in index to select current last webview if deleted webview was last one
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    // Select the new last webview
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    
    // Stack the webViews vertically if the app becomes too small (when multitasking with another open app)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    // When webView finishes loading a web page
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
    
    // Update title and address bar text when a webView is selected
    func updateUI(for webView: WKWebView) {
        title = webView.title
        addressBar.text = webView.url?.absoluteString ?? ""
    }
}

