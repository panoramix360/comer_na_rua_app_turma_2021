//
//  PhotoFilterViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 26/08/21.
//

import UIKit
import AVFoundation

class PhotoFilterViewController: UIViewController {

    @IBOutlet var exampleImage: UIImageView!
    @IBOutlet var filterCollectionView: UICollectionView!
    
    let manager = FilterDataManager()
    var filters: [FilterItem] = []
    
    var image: UIImage?
    var thumbnail: UIImage?
    
    var selectedRestaurantID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    @IBAction func onPhotoTapped(_ sender: UIBarButtonItem) {
        checkSource()
    }
}

// MARK: - Private Extension
private extension PhotoFilterViewController {
    func initialize() {
        setupCollectionView()
        checkSource()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 7
        
        filterCollectionView.collectionViewLayout = layout
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
    }
    
    func checkSource() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            self.showCameraUserInterface()
        case .restricted, .denied:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: cameraMediaType) {
                granted in
                
                if granted {
                    DispatchQueue.main.async {
                        self.showCameraUserInterface()
                    }
                }
            }
        default:
            break
        }
    }
    
    func showApplyFilter() {
        manager.fetch {
            items in
            
            filters = items
            if let image = self.image {
                exampleImage.image = image
                filterCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension PhotoFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
        
        let item = self.filters[indexPath.row]
        
        if let img = self.thumbnail {
            cell.set(image: img, item: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.filters[indexPath.item]
        filterSelected(item: item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = collectionView.frame.size.height
        let screenWithMargin = screenRect - 14
        
        return CGSize(width: 150, height: screenWithMargin)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension PhotoFilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    func showCameraUserInterface() {
        #if targetEnvironment(simulator)
        let imagePicker = imagePicker(for: .photoLibrary)
        #else
        let imagePicker = imagePicker(for: .camera)
        imagePicker.showsCameraControls = true
        #endif
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let img = image {
            self.image = generate(image: img, ratio: CGFloat(752))
            self.thumbnail = generate(image: img, ratio: CGFloat(102))
        }
        
        picker.dismiss(animated: true) {
            self.showApplyFilter()
        }
    }
    
    func generate(image: UIImage, ratio: CGFloat) -> UIImage {
        let size = image.size
        
        var croppedSize: CGSize?
        
        var offsetX: CGFloat = 0.0
        var offsetY: CGFloat = 0.0
        
        if size.width > size.height {
            offsetX = (size.height - size.width) / 2
            croppedSize = CGSize(width: size.height, height: size.height)
        } else {
            offsetY = (size.width - size.height) / 2
            croppedSize = CGSize(width: size.width, height: size.width)
        }
        
        guard let cropped = croppedSize,
              let cgImage = image.cgImage else {
            return UIImage()
        }
        
        let clippedRect = CGRect(x: offsetX * -1, y: offsetY * -1, width: cropped.width, height: cropped.height)
        
        let imgRef = cgImage.cropping(to: clippedRect)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: ratio, height: ratio)
        
        UIGraphicsBeginImageContext(rect.size)
        
        if let ref = imgRef {
            UIImage(cgImage: ref).draw(in: rect)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let finImage = finalImage else {
            return UIImage()
        }
        
        return finImage
    }
}

// MARK: - ImageFiltering
extension PhotoFilterViewController: ImageFiltering {
    func filterSelected(item: FilterItem) {
        if let img = image {
            if item.filter != "None" {
                exampleImage.image = self.apply(filter: item.filter, originalImage: img)
            } else {
                exampleImage.image = img
            }
        }
    }
}
