//
//  DetailViewController.swift
//  Milestone #4 - Challenge
//
//  Created by Tony Alhwayek on 8/10/23.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    
    var selectedImage: String?
    var imageCaption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageName = selectedImage {
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            imageView.image = UIImage(contentsOfFile: imagePath.path)
        }
        
        captionLabel.text = imageCaption
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
