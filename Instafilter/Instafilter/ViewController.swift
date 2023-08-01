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
    
    // Used for challenge #2
    @IBOutlet var changeFilterButton: UIButton!
    
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
    
    // Create menu that lets users choose filter
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Generate size of pop over based on current device
        if let popOverController = ac.popoverPresentationController {
            popOverController.sourceView = sender
            popOverController.sourceRect = sender.bounds
        }
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        // Make sure there is an image
        guard currentImage != nil else { return }
        // Get title
        guard let actionTitle = action.title else { return }
        // Get current filter using name from list
        currentFilter = CIFilter(name: actionTitle)
        
        // Apply filter to image
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        // For challenge #2
        // Set filter button's title as selected filter
        changeFilterButton.setTitle(actionTitle, for: .normal)
        // Apply filter
        applyProcessing()
    }
    
    // Save the image to the user's gallery
    @IBAction func save(_ sender: Any) {
        // Check if there is an image to avoid crashing
        guard let image = imageView.image else {
            // Challenge #1
            let ac = UIAlertController(title: "No image selected", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            return
        }
        

        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // If the slider's value was changed
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    // Apply the filter
    func applyProcessing() {
        
        let inputKeys = currentFilter.inputKeys
        
        // If filter supports intensity, use it
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        // If filter supports radius, use it but * 200 to amplify it
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        
        // If filter supports scaling
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        // If filter supports centering
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        // Safely check if an image exits
        guard let outputImage = currentFilter.outputImage else { return }
        
        // Create cgImage with the same size as our image and using the filter
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            // Conver to UIImage
            let processedImage = UIImage(cgImage: cgImage)
            // Display the image
            self.imageView.image = processedImage
        }
    }
    
    // Check if image saved properly or encountered an error
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Present alert controller if image could not be saved due to an error
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            // Present alert controller if image was successfully saved
            let ac = UIAlertController(title: "Image saved!", message: "Your edited image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

