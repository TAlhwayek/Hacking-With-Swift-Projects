//
//  ViewController.swift
//  Milestone #5 - Challenge
//
//  Created by Tony Alhwayek on 8/16/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Country Facts"
        loadCountries()
    }
    
    // Generate the needed number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    // Populate rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }
    
    // When a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailViewController {
            // Send all details to next view controller
            let country = countries[indexPath.row]
            detailVC.name = country.name
            detailVC.capital = country.capital
            detailVC.population = country.population
            detailVC.yearEstablished = country.yearEstablished
            detailVC.coordinates = country.coordinates
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // Populate countries array
    func loadCountries() {
        do {
            // Load the JSON file's data
            guard let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") else {
                fatalError("JSON file not found. Do you have the correct name?")
            }
            
            let jsonData = try Data(contentsOf: fileURL)
            // Decode the JSON data
            let decoder = JSONDecoder()
            countries = try decoder.decode([Country].self, from: jsonData)
            
            // Sort countries by name
            countries.sort { $0.name < $1.name }
            tableView.reloadData()
            
        } catch {
            print("Error: \(error)")
        }
    }
}

