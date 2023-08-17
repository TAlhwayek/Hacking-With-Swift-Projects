//
//  Country.swift
//  Milestone #5 - Challenge
//
//  Created by Tony Alhwayek on 8/16/23.
//

import UIKit

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

class Country: NSObject, Codable {
    var name: String
    var capital: String
    var yearEstablished: Int
    var population: String
    var coordinates: Coordinates
    
    init(name: String, capital: String, yearEstablished: Int, population: String, coordinates: Coordinates) {
        self.name = name
        self.capital = capital
        self.yearEstablished = yearEstablished
        self.population = population
        self.coordinates = coordinates
    }
}
