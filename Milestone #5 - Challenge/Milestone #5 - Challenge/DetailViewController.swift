//
//  DetailViewController.swift
//  Milestone #5 - Challenge
//
//  Created by Tony Alhwayek on 8/16/23.
//

import UIKit

class DetailViewController: UITableViewController {

    //var flag: UIImage!
    var name: String!
    var capital: String!
    var yearEstablished: Int!
    var population: String!
    var coordinates: Coordinates!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = name
        // Do any additional setup after loading the view.
    }

}
