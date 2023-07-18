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
        
        // Create new UIProgressView instance
        progressView = UIProgressView(progressViewStyle: .default)
        // Fully fit content (take as much space as needed)
        progressView.sizeToFit()
        // Define the progress button
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // Add items to toolbar and make it visible
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // Create an observer to track WebView's progress
        // This makes the progress bar actually contain a value
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Assign value to URL
        let url = URL(string: "https://www.hackingwithswift.com")!
        
        // Load the URL
        webView.load(URLRequest(url: url))
        
        // Enable gestures for easy-of-use
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        // Add websites
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "github.com/TAlhwayek", style: .default, handler: openPage))
            
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}

