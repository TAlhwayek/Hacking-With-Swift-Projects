//
//  ViewController.swift
//  Debugging
//
//  Created by Tony Alhwayek on 8/5/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prints
        print("I'm inside the viewDidLoad() method")
        print(1, 2, 3, 4, 5)
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
        print("again")
        print("Another message", terminator: "OOOOOOOOOOOOOO")
        
        // Assert
        assert(1 == 1, "Math failure!")
        // assert(1 == 2, "Math(2) failure!")
        
        // Breakpoint test
        for i in 1...100 {
            print("Got number \(i)")
        }
    }


}

 
