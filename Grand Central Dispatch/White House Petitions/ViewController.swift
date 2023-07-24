//
//  ViewController.swift
//  White House Petitions
//
//  Created by Tony Alhwayek on 7/20/23.
//

import UIKit

class ViewController: UITableViewController {
    
    // Array to store petitions
    var petitions = [Petition]()
    // Needed for challenge 2
    // Stores data after a filter is applied
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Challenge 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .checkmark, style: .plain, target: self, action: #selector(creditsTapped))
        
        // Challenge 2
        // Filter button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterTapped))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        // Convert string to URL
        if let url = URL(string: urlString) {
            // Convert URL to data instance (blocking call)
            if let data = try? Data(contentsOf: url) {
                // Parse data
                parse(json: data)
                return
            }
        }
        // Show error if data could not be loaded on MAIN thread
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            // Get data from json and put in array
            petitions = jsonPetitions.results
            // For challenge 2
            // Populate filteredPetitions since it is the one being displayed
            // petitions just acts as a 'database' right now
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    // Generate needed number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    // Modify cell text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    // Go to new vc when a row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // For challenge 1
    // Present an alert providing the data's source
    @objc func creditsTapped() {
        let ac = UIAlertController(title: "Verified Data", message: "Data comes from the \"We Are The People\" official API.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // For challenge 2
    // Filters petitions
    @objc func filterTapped() {
        let filterAC = UIAlertController(title: "Filter by keyword", message: nil, preferredStyle: .alert)
        filterAC.addTextField()
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) {
            [weak self, weak filterAC] _ in
            // Capture entered keyword(s)
            guard let keywords = filterAC?.textFields?[0].text else { return }
            self?.filter(keywords)
        }
        filterAC.addAction(filterAction)
        present(filterAC, animated: true)
    }
    
    // Challange 2
    func filter(_ filter: String) {
        // Clear out the array to make room for filtered items
        filteredPetitions.removeAll()
        
        // Scan entire array
        for item in petitions {
            // Check if each item contains the keyword in body/title
            if item.title.contains(filter) || item.body.contains(filter) {
                // Add item to filtered array
                filteredPetitions.append(item)
            }
        }
        
        // Check if new array is empty and present an error
        if(filteredPetitions.isEmpty) {
            let ac = UIAlertController(title: "Search yielded no results", message: "Please enter a different keyword", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            // Reload all data back into filtered array to display something
            filteredPetitions = petitions
        }
        tableView.reloadData()
    }
}

