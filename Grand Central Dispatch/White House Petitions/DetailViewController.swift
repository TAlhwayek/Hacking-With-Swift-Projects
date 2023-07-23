//
//  DetailViewController.swift
//  White House Petitions
//
//  Created by Tony Alhwayek on 7/20/23.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        // Create custom HTML to display petition
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body {
        font-size: 150%;
        text-align: center;
        } </style>
        <head>
        <body>
        <font face = "Helvetica">
        <h3>\(detailItem.title)</h3>
        <p>\(detailItem.body)</p>
        </font>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
