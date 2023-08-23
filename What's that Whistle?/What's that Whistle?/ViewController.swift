//
//  ViewController.swift
//  What's that Whistle?
//
//  Created by Tony Alhwayek on 8/22/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "What's that Whistle?"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }

    @objc func addWhistle() {
        let whistleVC = RecordWhistleViewController()
        navigationController?.pushViewController(whistleVC, animated: true)
    }

}

