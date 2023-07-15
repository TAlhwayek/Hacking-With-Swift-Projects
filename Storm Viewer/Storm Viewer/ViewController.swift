//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Tony Alhwayek on 7/15/23.
//

import UIKit

class ViewController: UITableViewController {
    
    // Array to store pictures
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        print(pictures)
    }


}

