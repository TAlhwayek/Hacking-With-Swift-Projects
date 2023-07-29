//
//  Person.swift
//  Names to Faces
//
//  Created by Tony Alhwayek on 7/24/23.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
