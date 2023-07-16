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
        
        // Assign value to URL
        let url = URL(string: "https://www.hackingwithswift.com")!
        
        // Load the URL
        webView.load(URLRequest(url: url))
        
        // Enable gestures for easy-of-use
        webView.allowsBackForwardNavigationGestures = true
    }


}

