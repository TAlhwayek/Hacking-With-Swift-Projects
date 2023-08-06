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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Get all flags from assets
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // Add all flags to array
        for flag in items {
            if flag.hasSuffix("@3x.png") {
                // Add flags to array
                flags.append(flag)
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
        
        // Just some formatting
        // Remove "@3x.png"
        var fixedFlagName = flags[indexPath.row].replacingOccurrences(of: "@3x.png", with: "")
        
        // Capitalize entire flag name if 2 letters or less
        // Else, capitalize the first letter
        if fixedFlagName.count <= 2 {
            fixedFlagName = fixedFlagName.uppercased()
        } else {
            fixedFlagName = fixedFlagName.prefix(1).uppercased() + fixedFlagName.dropFirst()
        }
        // Use the fixed name in table
        cell.textLabel?.text = fixedFlagName
        
        // Bonus
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            detailVC.selectedFlag = flags[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
            
        }
    }
}

