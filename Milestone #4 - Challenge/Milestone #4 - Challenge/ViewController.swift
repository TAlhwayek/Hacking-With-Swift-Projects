//
//  ViewController.swift
//  Milestone #4 - Challenge
//
//  Created by Tony Alhwayek on 8/10/23.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Array to store all pictures
    var pictures = [Memory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Memories"
        
        // Add button to let user add a photos
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        // Load data
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            if let decodedPictures = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPictures) as? [Memory] {
                pictures = decodedPictures
            }
        }

    }
    
    
    // Generate the needed number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // Details to show in table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let memory = pictures[indexPath.row]
        // Set the caption of the Memory object as the text of the cell's label
        cell.textLabel?.text = memory.caption
        return cell
    }

    // When a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailViewController {
            let memory = pictures[indexPath.row] // Get the Memory object at the selected index
            
            detailVC.selectedImage = memory.image
            detailVC.imageCaption = memory.caption
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpedData = image.jpegData(compressionQuality: 1.0) {
            try? jpedData.write(to: imagePath)
        }
        dismiss(animated: true)
        
        // Prompt user for caption
        let captionAC = UIAlertController(title: "Enter a caption", message: nil, preferredStyle: .alert)
        captionAC.addTextField()
        
        // Submit caption
        // Add memory object to array
        // Reload table
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak captionAC] _ in
            guard let caption = captionAC?.textFields?[0].text else { return }
            self?.pictures.append(Memory(image: imageName, caption: caption))
            self?.tableView.reloadData()
            self?.save()
        }
        
        captionAC.addAction(submitAction)
        present(captionAC, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Add photo
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        
        // Added a new alert that lets the user choose between camera or gallery
        let cameraAC = UIAlertController(title: "Camera or gallery?", message: nil, preferredStyle: .alert)
        
        // If user chose camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            // Make sure camera is available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
            }
        }
        
        // If user chose gallery
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add all actions to alert and present
        cameraAC.addAction(cameraAction)
        cameraAC.addAction(galleryAction)
        cameraAC.addAction(cancelAction)
        present(cameraAC, animated: true)
    }
    
    // Save user's data
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: pictures, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        }
    }
}

