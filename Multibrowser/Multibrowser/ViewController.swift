//
//  ViewController.swift
//  Multibrowser
//
//  Created by Tony Alhwayek on 8/15/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {

    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        // Add two right bar button items
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [add, delete]
    }

    // Set title of the app
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    @objc func addWebView() {
        // Create new webview
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        // Casual self-plug
        let url = URL(string: "https://www.\(addressBar.text ?? "https://github.com/TAlhwayek")")!
        // Load specified URL
        webView.load(URLRequest(url: url))
    }
    
    @objc func deleteWebView() {
        
    }
}

