//
//  ViewController.swift
//  Easy Browser
//
//  Created by Tony Alhwayek on 7/16/23.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!

    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

