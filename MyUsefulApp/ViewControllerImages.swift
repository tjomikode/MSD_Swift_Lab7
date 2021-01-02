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
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonBarAddPicture: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        loadImagesAPI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImageToCollectionView))
        alertDisabilityToTakeAPhotoByNow = UIAlertController(title: "Warning", message: "I can't open the camera. It is simulator.", preferredStyle: UIAlertController.Style.alert)
        alertDisabilityToTakeAPhotoByNow.addAction(UIAlertAction(title: "Click", style: .cancel, handler: nil))
    }
    
    @objc fileprivate func addNewImageToCollectionView() {
        showImagePickerControllerActionSheet()
    }
    
    public func loadImagesAPI() {
        let urlApi = "https://pixabay.com/api/?key=19193969-87191e5db266905fe8936d565&q=fun+party&image_type=photo&per_page=30"
        let url = URL(string: urlApi)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        if let arrayImg = myJson["hits"] as? [NSDictionary] {
                            for data in arrayImg {
                                if let newImg = data["largeImageURL"] {
                                    let imageUrl = String(describing: newImg)
                                    let url = URL(string: imageUrl)
                                    let data = try? Data(contentsOf: url!)
                                    self.images.append(UIImage(data: data!)!)
                                }
                            }
                        }
                    }
                    catch {
                        print("Error in JSONSerialization")
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
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

