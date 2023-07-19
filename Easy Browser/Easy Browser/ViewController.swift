//
//  ViewController.swift
//  Easy Browser
//
//  Created by Tony Alhwayek on 7/16/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    // List of allowed websites
    var websites = ["apple.com", "hackingwithswift.com", "google.com"]
    
    override func loadView() {
        // Create instance of WKWebView class
        webView = WKWebView()
        
        // Modify navigation delegate
        webView.navigationDelegate = self
        
        // Make it the ViewController's view
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add right-side navigation bar item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // Create toolbar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // Add refresh button
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // Add back and forward buttons
        let goBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackAction))
        let goForwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(goForwardAction))
        
        // Create new UIProgressView instance
        progressView = UIProgressView(progressViewStyle: .default)
        // Fully fit content (take as much space as needed)
        progressView.sizeToFit()
        // Define the progress button
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // Add items to toolbar and make it visible
        toolbarItems = [goBackButton, progressButton, spacer, refresh, goForwardButton]
        navigationController?.isToolbarHidden = false
        
        // Create an observer to track WebView's progress
        // This makes the progress bar actually contain a value
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Assign value to URL
        let url = URL(string: "https://" + websites[0])!
        
        // Load the URL
        webView.load(URLRequest(url: url))
        
        // Enable gestures for easy-of-use
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        // Add UIAlertController
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
         
        // Add a list of websites
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
            
        // Dedicated cancel button
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Needed for iPads
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        // Guard functionality to avoid any headaches
        guard let actionTitle = action.title else { return }
        guard let url =  URL(string: "https://" + actionTitle) else { return }
        
        // Load the requested URL
        webView.load(URLRequest(url: url))
    }

    // Add title to view
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    // This allows the progress bar to fill up
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // Decide whether we want to allow a navigation to happen
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        // Get domain
        if let host = url?.host {
            print(host)
            // Loop through safelist
            for website in websites {
                // Check if each safe website exists in visisted url
                // i.e check if apple.com, hackingwithswift.com, etc exist in visited website
                if host.contains(website) {
                    // Allow loading
                    decisionHandler(.allow)
                    return
                }
            }
        }
        // If the "if let" fails, or if website is not safelisted
        // Present an alert and disallow loading
        // For some reason this (the alert) is popping up on approved websites
        // Need to fix but I don't know how to
        let ac = UIAlertController(title: "Website access is blocked", message: "This website is not approved", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Proceed", style: .default, handler: nil))
                present(ac, animated: true)
        // Cancel loading a website if it's blocked
        decisionHandler(.cancel)
    }
    
    
    // These are part of one of the challenges
    // Go back funtionality
    @objc func goBackAction() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    // Go forward functionality
    @objc func goForwardAction() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}

