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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        // Convert string to URL
        if let url = URL(string: urlString) {
            // Convert URL to data instance
            if let data = try? Data(contentsOf: url) {
                // Parse data
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            // Get data from json and put in array
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    // Generate needed number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    // Modify cell text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    // Go to new vc when a row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

