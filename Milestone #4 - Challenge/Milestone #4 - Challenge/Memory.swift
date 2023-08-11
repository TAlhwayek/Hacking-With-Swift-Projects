//
//  Memory.swift
//  Milestone #4 - Challenge
//
//  Created by Tony Alhwayek on 8/11/23.
//

import UIKit

class Memory: NSObject, NSCoding {

    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
    
    required init?(coder: NSCoder) {
        image = coder.decodeObject(forKey: "image") as? String ?? ""
        caption = coder.decodeObject(forKey: "caption") as? String ?? ""
    }

    func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(caption, forKey: "caption")
    }
    

    
}
