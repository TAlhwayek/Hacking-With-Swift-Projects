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
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Use file manager to get the images
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        // Sort images in ascending order
        pictures.sort()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Generate needed rows
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // Set row title as picture name
        cell.textLabel?.text = pictures[indexPath.row]
        // Return that cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            // Get index of selected image
            vc.index = indexPath.row + 1
            // Get total numbers of images
            vc.imageCount = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

