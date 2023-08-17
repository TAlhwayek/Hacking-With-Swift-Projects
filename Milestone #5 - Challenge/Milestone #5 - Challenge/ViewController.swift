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
    }
    
    // Generate the needed number of rows
    override func numberOfSections(in tableView: UITableView) -> Int {
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
            detailVC.flag = country.flag
            detailVC.name = country.name
            detailVC.capital = country.capital
            detailVC.population = country.population
            detailVC.yearEstablished = country.yearEstablished
            detailVC.coordinates = country.coordinates
        }
    }
    
    // Populate countries array


}

