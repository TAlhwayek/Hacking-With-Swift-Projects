//
//  ViewController.swift
//  SwiftSearcher
//
//  Created by Tony Alhwayek on 8/20/23.
//

import CoreSpotlight
import MobileCoreServices
import SafariServices
import UIKit

class ViewController: UITableViewController {

    // Array inside an array to store the projects
    var projects = [[String]]()
    
    // Store favorite tutorials
    var favorites = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Swift Searcher"
        
        // Stuff all the projects into the array
        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
        
        // Set table view to editing mode
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        // Load saved favorites
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: "favorites") as? [Int] {
            favorites = savedFavorites
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let project = projects[indexPath.row]
        // Customize the cell text
        cell.textLabel?.attributedText = makeAttributedString(title: project[0], subtitle: project[1])
        cell.textLabel?.numberOfLines = 0
        
        // Place a checkmark in the row if it's been favorited
        if favorites.contains(indexPath.row) {
            cell.editingAccessoryType = .checkmark
        } else {
            cell.editingAccessoryType = .none
        }
        
        return cell
    }
    
    // Show the tutorial in Safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    // Add or remove from favorites
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if favorites.contains(indexPath.row) {
            return .delete
        } else {
            return .insert
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Add item to favorites array
        if editingStyle == .insert {
            favorites.append(indexPath.row)
            index(item: indexPath.row)
        // Remove item from favorites
        } else {
            if let index = favorites.firstIndex(of: indexPath.row) {
                favorites.remove(at: index)
                deindex(item: indexPath.row)
            }
        }
        
        // Save favorites
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favorites")
        
        // Reload the specified row with no animation
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // Index items for spotlight
    func index(item: Int) {
        let project = projects[item]
        
        let attributedSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributedSet.title = project[0]
        attributedSet.contentDescription = project[1]
        
        let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: attributedSet)
        item.expirationDate = Date.distantFuture
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed")
            }
        }
    }
    
    func deindex(item: Int) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]) { error in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully removed!")
            }
        }
    }
    
    // Edit the titles and subtitles of each row
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSMutableAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }
    
    // Generate the links needed to show each tutorial
    func showTutorial(_ which: Int) {
        if let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") {
            let config = SFSafariViewController.Configuration()
            // Use Safari's reader, if available
            config.entersReaderIfAvailable = true
            // Display webpage
            let safariVC = SFSafariViewController(url: url, configuration: config)
            present(safariVC, animated: true)
        }
    }
    


}

