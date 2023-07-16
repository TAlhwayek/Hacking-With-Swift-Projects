//
//  DetailViewController.swift
//  Storm Viewer
//
//  Created by Tony Alhwayek on 7/15/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    

    @IBOutlet var imageView: UIImageView!
    
    
    var selectedImage: String?
    
    // To show image X of Y
    var index: Int!
    var imageCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make navigation bar appear (not transparent)
        let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = "Image \(index ?? 1) of \(imageCount ?? 10)"
        // Make image titles small
        navigationItem.largeTitleDisplayMode = .never
        
        // Add navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
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
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
