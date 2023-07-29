//
//  Person.swift
//  Names to Faces
//
//  Created by Tony Alhwayek on 7/24/23.
//

import UIKit

// Codable allows reading and writing
class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
