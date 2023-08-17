//
//  DetailViewController.swift
//  Milestone #5 - Challenge
//
//  Created by Tony Alhwayek on 8/16/23.
//

import UIKit

class DetailViewController: UITableViewController {
    
    //var flag: UIImage!
    var name: String?
    var capital: String?
    var yearEstablished: Int?
    var population: String?
    var coordinates: Coordinates?
    
    var countryInfo: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryInfo = Country(name: name!, capital: capital!, yearEstablished: yearEstablished!, population: population!, coordinates: coordinates!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Wiki", style: .plain, target: self, action: #selector(openWiki))
        
        title = name
    }
    
    // Fill up the table with the info about each country
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        switch indexPath.row {
              case 0:
                  cell.textLabel?.text = "Name: \(countryInfo!.name)"
                  
              case 1:
                  cell.textLabel?.text = "Capital: \(countryInfo!.capital)"
                  
              case 2:
                  cell.textLabel?.text = "Year Established: \(countryInfo!.yearEstablished)"
                  
              case 3:
                  cell.textLabel?.text = "Population: \(countryInfo!.population)"
                  
              case 4:
                  cell.textLabel?.text = "Coordinates: [\(countryInfo!.coordinates.longitude), \(countryInfo!.coordinates.latitude)]"
                  
              default:
                  break
              }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    @objc func openWiki() {
        print("Go to wikipedia you lazy bum")
    }
}
