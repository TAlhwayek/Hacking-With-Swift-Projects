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
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }


}

