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
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
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
        
        // Add both actions to the button
        firstAC.addAction(renameAction)
        firstAC.addAction(deleteAction)
        
        // Present main AC
        present(firstAC, animated: true)
        
        
    }
    
    @objc func renamePerson() {
        
    }
}

