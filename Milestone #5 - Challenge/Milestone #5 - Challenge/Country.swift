//
//  Country.swift
//  Milestone #5 - Challenge
//
//  Created by Tony Alhwayek on 8/16/23.
//

import UIKit

class Country: NSObject {
    var flag: UIImage
    var name: String
    var capital: String
    var yearEstablished: Int
    var population: String
    var coordinates: (Int, Int)
    
    init(flag: UIImage, name: String, capital: String, yearEstablished: Int, population: String, coordinates: (Int, Int)) {
        self.flag = flag
        self.name = name
        self.capital = capital
        self.yearEstablished = yearEstablished
        self.population = population
        self.coordinates = coordinates
    }
}
