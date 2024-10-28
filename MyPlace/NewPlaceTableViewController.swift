//
//  NewPlaceTableViewController.swift
//  MyPlace
//
//  Created by user246073 on 10/27/24.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    var currentPlace: Place?
    var imageIsChanged = false

    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var cancelbutton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        nameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        settingScreen()
    }
    
//MARK: Table View Delegate
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cameraIcon = UIImage(systemName: "camera")
    let photoIcon = UIImage(systemName: "photo")
    
    if indexPath.row == 0 {
        let actionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(sourse: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(sourse: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    } else {
        view.endEditing(true)
    }
}

    private func settingScreen() {
        if currentPlace != nil {
            setupNavigationBar()
            guard let data = currentPlace?.imageData,
                  let image = UIImage(data: data) else { return }
            imageIsChanged = true

            placeImage.image = image
            placeImage.contentMode = .scaleAspectFit
            nameTF.text = currentPlace?.name
            locationTF.text = currentPlace?.location
            typeTF.text = currentPlace?.type
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func saveNewPlace() {
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        } else {
            let defaultImage = UIImage(systemName: "fork.knife")?.withTintColor(.orange)
            image = defaultImage
        }
    
        let imageData = image?.pngData()
        
        if imageIsChanged, let place = currentPlace {
            StorageManager.edit(
                place,
                name: nameTF.text,
                location: locationTF.text,
                type: typeTF.text,
                imageData: imageData
            )
        } else {
            let newPlace = Place(
                name: nameTF.text!,
                location: locationTF.text,
                type: typeTF.text,
                imageData: imageData
            )
            StorageManager.saveobject(newPlace)
        }
        saveButton.isEnabled = false
        imageIsChanged = false
    }
}

//MARK: work with image
extension NewPlaceTableViewController: UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleToFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
}

//MARK: Text Field Delegate
extension NewPlaceTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if let name = nameTF.text?.trimmingCharacters(in:
                .whitespacesAndNewlines), !name.isEmpty {
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
    }
}
