//
//  Petition.swift
//  White House Petitions
//
//  Created by Tony Alhwayek on 7/20/23.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
