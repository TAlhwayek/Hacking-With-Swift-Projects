//
//  ViewController.swift
//  Names to Faces
//
//  Created by Tony Alhwayek on 7/24/23.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        // Read in saved data
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as ? [Person] {
                people = decodedPeople
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        // Add names to each label
        let person = people[indexPath.item]
        cell.name.text = person.name
        cell.name.textColor = .black
        
        // Assign image to a cell
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        // Create border
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        // Rounded borders
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    
    // This entire section was modified for challenge #2
    @objc func addNewPerson() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Attemp to find edited image and cast it as a UIImage
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        // Add new person to collection view
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        // Save to disk
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        // Challenge 1
        // Present a new alert controller that asks the user whether they want to rename or delete the selected view
        // Main alert controller
        let firstAC = UIAlertController(title: "Delete or rename?", message: nil, preferredStyle: .alert)
        
        // Rename button
        let renameAction = UIAlertAction(title: "Rename", style: .default) { _ in
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                // Save to disk
                self?.save()
                self?.collectionView.reloadData()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac, animated: true)
        }
        
        // Delete button
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            // Remove person from people array
            self.people.remove(at: indexPath.item)
            // Delete item from collection view
            self.collectionView.deleteItems(at: [indexPath])
            // Update collection view
            collectionView.reloadData()
        }
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add all actions to the button
        firstAC.addAction(renameAction)
        firstAC.addAction(deleteAction)
        firstAC.addAction(cancelAction)
        
        // Present main AC
        present(firstAC, animated: true)
    }
}

