//
//  ViewControllerImages.swift
//  MyUsefulApp
//
//  Created by amooyts on 22.11.2020.
//

import Foundation
import UIKit

class ViewControllerImages: UIViewController {
    
    var images: [UIImage] = []
    var alertDisabilityToTakeAPhotoByNow: UIAlertController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonBarAddPicture: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImageToCollectionView))
        alertDisabilityToTakeAPhotoByNow = UIAlertController(title: "Warning", message: "I can't open the camera. It is simulator.", preferredStyle: UIAlertController.Style.alert)
        alertDisabilityToTakeAPhotoByNow.addAction(UIAlertAction(title: "Click", style: .cancel, handler: nil))
    }
    
    @objc fileprivate func addNewImageToCollectionView() {
        showImagePickerControllerActionSheet()
    }
    
}

extension ViewControllerImages: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImage", for: indexPath) as? ImagesCollectionViewCell else {
            fatalError("Unable to dequeue ImagesCollectionViewCell...")
        }
        let image = images[indexPath.item]
        cell.photoView.image = image
        
        return cell
    }
}

extension ViewControllerImages: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Take a picture using Camera", style: .default) { (action) in
            //self.showImagePickerController(sourceType: .camera)
            self.present(self.alertDisabilityToTakeAPhotoByNow, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel...", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Choose the photo", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            images.append(editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(originalImage)
        }
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

