//
//  ViewController.swift
//  Instafilter
//
//  Created by Tony Alhwayek on 7/30/23.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    
    // Display the main image
    var currentImage: UIImage!
    
    // For filters
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        // Apply a sepia filter
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    // Allow getting user's photos
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // When user chooses an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        // Make the current image editable
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        // Apply filter
        applyProcessing()
    }
    


    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    // If the slider's value was changed
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    func applyProcessing() {
        guard let image = currentFilter.outputImage else { return }
        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        
        // Create cgImage with the same size as our image and using the filter
        if let cgImage = context.createCGImage(image, from: image.extent) {
            // Conver to UIImage
            let processedImage = UIImage(cgImage: cgImage)
            // Display the image
            imageView.image = processedImage
        }
    }
}

