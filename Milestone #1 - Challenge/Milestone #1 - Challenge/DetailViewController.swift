//
//  DetailViewController.swift
//  Milestone #1 - Challenge
//
//  Created by Tony Alhwayek on 8/5/23.
//

import UIKit

class DetailViewController: UIViewController {
    

    @IBOutlet var imageView: UIImageView!
    var selectedFlag: String?
    var flagName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Let nav bar appear
        let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Make background slightly off-white so that flags can be properly seen
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        if let flagToDisplay = selectedFlag {
            imageView.image = UIImage(named: flagToDisplay)
        }
        
        // Add share button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            let ac = UIAlertController(title: "Error", message: "Image not found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, selectedFlag!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
