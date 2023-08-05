//
//  ViewController.swift
//  Milestone #1 - Challenge
//
//  Created by Tony Alhwayek on 8/5/23.
//

import UIKit

class ViewController: UITableViewController {

    // Array to store flags
    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = "Flags"
        
        // Get all flags from assets
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // Add all flags to array
        for flag in items {
            if flag.hasSuffix("@3x.png") {
                flags.append(flag)
                print("\(flag) appended")
            }
        }
        
        // Sort alphabetically
        flags.sort()
    }

    // Generate number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row]
        return cell
    }
    
}

