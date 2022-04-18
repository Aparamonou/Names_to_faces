//
//  ViewController.swift
//  Names_to_Faces
//
//  Created by Alex Paramonov on 29.03.22.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
     var people = [Person]()
     let imagePicker = UIImagePickerController()
     
     override func viewDidLoad() {
          super.viewDidLoad()
          setLeftBarButton()
     }
     
     
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return people.count
     }
     
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else { fatalError("Unable to dequeue PersonCell.")	}
          
          let person = people[indexPath.item]
          cell.name.text = person.name
          
          let path = getDocumentDirectory().appendingPathComponent(person.image)
          cell.imageView.image = UIImage(contentsOfFile: path.path)
          
          cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
          cell.imageView.layer.borderWidth = 2
          cell.imageView.layer.cornerRadius = 3
          cell.layer.cornerRadius = 7
          
          
          return cell
     }
     
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
          let persen = people[indexPath.item]
          
          let aleretController = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
          aleretController.addTextField()
          aleretController.addAction(UIAlertAction(title: "Canel", style: .cancel))
          aleretController.addAction(UIAlertAction(title: "rename", style: .default) { [weak self, weak aleretController ] _ in
               
               guard let newName = aleretController?.textFields?[0].text else {return}
               
               persen.name = newName
               
               self?.collectionView.reloadData()
               
          } )
          aleretController.addAction(UIAlertAction(title: "delete", style: .default, handler: { UIAlertAction in
               self.people.remove(at: indexPath.item)
               self.collectionView.reloadData()
               self.save()
          }))
          present(aleretController, animated: true)
     }
     
     
     
     private func setLeftBarButton() {
          
          navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddNewPerson))
     }
     
     @objc func AddNewPerson() {
          
          let ac = UIAlertController(title: "Add new person", message: nil, preferredStyle: .actionSheet)
          ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { UIAlertAction in
               self.openCamera()
          }))
          ac.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { UIAlertAction in
               self.openGallery()
          }))
          
          ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          
          present(ac, animated: true)
     }
     
     
     private func openCamera() {
          if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
          {
               imagePicker.sourceType = UIImagePickerController.SourceType.camera
               imagePicker.allowsEditing = true
               self.present(imagePicker, animated: true, completion: nil)
          }
          else
          {
               let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
          }
     }
     
     private func openGallery() {
          
          let picker = UIImagePickerController()
                    picker.allowsEditing = true
                    picker.delegate = self
                    present(picker, animated: true)
     }
     
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          guard let image = info[.editedImage] as? UIImage else {return}
          
          
          let imageName = UUID().uuidString
          let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
          
          if let jpegData = image.jpegData(compressionQuality: 0.8) {
               try? jpegData.write(to: imagePath)
          }
          let person = Person(name: "Unknown", image: imageName)
          people.append(person)
          collectionView.reloadData()
          save()
          dismiss(animated: true)
     }
     
     func getDocumentDirectory() -> URL {
          let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
          return paths[0]
     }
     
     private func save() {
          if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
               let defaults = UserDefaults.standard
               defaults.set(saveData, forKey: "people")
          }
     }
     
     
}

