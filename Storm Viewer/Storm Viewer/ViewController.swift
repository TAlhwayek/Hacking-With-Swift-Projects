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
    
    // Array to count how many times each picture was accessed
    var openCount = [Int](repeating: 0, count: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        // Make main title large
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
        
        // Load data
        let defaults = UserDefaults.standard
        
        if let savedCount = defaults.object(forKey: "count") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                openCount = try jsonDecoder.decode([Int].self, from: savedCount)
            } catch {
                print("Error decoding the array: \(error)")
            }
        }
        
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
        // Increment the image's counter each time it's opened
        openCount[indexPath.row] += 1
        print("Image #\(indexPath.row + 1): \(openCount[indexPath.row])")
        save()
        // Get total numbers of images
        vc.imageCount = pictures.count
        navigationController?.pushViewController(vc, animated: true)
    }
}
    
    // Save data
    func save() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()

        do {
            let savedCount = try jsonEncoder.encode(openCount)
            defaults.set(savedCount, forKey: "count")
        } catch {
            print("Error enconding the array: \(error)")
        }
    }
}

