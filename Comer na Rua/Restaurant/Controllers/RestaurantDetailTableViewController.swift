//
//  RestaurantDetailTableViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import UIKit
import MapKit

class RestaurantDetailTableViewController: UITableViewController {
    
    // Célula 01
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cuisinesLabel: UILabel!
    @IBOutlet var headerAddressLabel: UILabel!
    
    // Célula 02
    @IBOutlet var tableDetailsLabel: UILabel!
    
    // Célula 03
    @IBOutlet var addressLabel: UILabel!
    
    // Célula 04
    @IBOutlet var mapAddressImage: UIImageView!
    
    @IBOutlet var overallRatingLabel: UILabel!
    
    @IBOutlet var ratingsView: RatingsView!
    
    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch Segue(rawValue: identifier) {
            case .showReview:
                showReview(segue: segue)
            case .showPhotoFilter:
                showPhotoFilter(segue: segue)
            default:
                print("Segue não encontrado")
            }
        }
    }
    
    @IBAction func onHeartTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onHourTapped(_ sender: UIButton) {
        if let textButton = sender.titleLabel?.text {
            checkNotificationPermission {
                isGranted in
                
                if isGranted {
                    self.showNotification(sender: textButton)
                }
            }
        }
    }
}

// MARK: - Private Extension
private extension RestaurantDetailTableViewController {
    func initialize() {
        setupLabels()
        setupRating()
        createMapImage()
    }
    
    func setupRating() {
        ratingsView.isEnabled = false
        
        if let id = selectedRestaurant?.restaurantID {
            let value = CoreDataManager.shared.fetchRestaurantRating(by: id)
            
            ratingsView.rating = Double(value)
            
            if value.isNaN {
                overallRatingLabel.text = "0.0"
            } else {
                let roundedValue = ((value * 10).rounded() / 10)
                overallRatingLabel.text = "\(roundedValue)"
            }
        }
    }
    
    func setupLabels() {
        guard let restaurant = selectedRestaurant else {
            return
        }
        
        if let name = restaurant.name {
            nameLabel.text = name
            title = name
        }
        
        if let cuisine = restaurant.subtitle {
            cuisinesLabel.text = cuisine
        }
        
        if let address = restaurant.address {
            addressLabel.text = address
            headerAddressLabel.text = address
        }
        
        tableDetailsLabel.text = "Mesa para 7, hoje a noite às 10:00 PM"
    }
    
    func createMapImage() {
        guard let annotation = selectedRestaurant,
              let long = annotation.long,
              let lat = annotation.lat else {
            return
        }
            
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        takeSnapshot(with: location)
    }
    
    func takeSnapshot(with location: CLLocationCoordinate2D) {
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        
        var loc = location
        let polyline = MKPolyline(coordinates: &loc, count: 1)
        let region = MKCoordinateRegion(polyline.boundingMapRect)
        
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: 340, height: 208)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.pointOfInterestFilter = .includingAll
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start() {
            snapshot, error in
            
            guard let snapshot = snapshot else {
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(mapSnapshotOptions.size, true, 0)
            
            snapshot.image.draw(at: .zero)
            
            let identifier = "custompin"
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.image = UIImage(named: "custom-annotation")
            
            var point = snapshot.point(for: location)
            
            let rect = self.mapAddressImage.bounds
            
            if rect.contains(point) {
                let pinCenterOffset = pinView.centerOffset
                point.x -= pinView.bounds.size.width / 2
                point.y -= pinView.bounds.size.height / 2
                
                point.x += pinCenterOffset.x
                point.y += pinCenterOffset.y
                
                let pinImage = pinView.image
                pinImage?.draw(at: point)
            }
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                
                DispatchQueue.main.async {
                    self.mapAddressImage.image = image
                }
            }
        }
    }
    
    func showReview(segue: UIStoryboardSegue) {
        guard let navController = segue.destination as? UINavigationController,
              let viewController = navController.topViewController as? ReviewFormTableViewController else {
            return
        }
        viewController.selectedRestaurantID = selectedRestaurant?.restaurantID
    }
    
    func showPhotoFilter(segue: UIStoryboardSegue) {
        guard let navController = segue.destination as? UINavigationController,
              let viewController = navController.topViewController as? PhotoFilterViewController else {
            return
        }
        viewController.selectedRestaurantID = selectedRestaurant?.restaurantID
    }
    
    func checkNotificationPermission(completion: @escaping (_ isGranted: Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {
            settings in
            
            switch settings.authorizationStatus {
            case .denied:
                // pedir autorização novamente
                break
            case .authorized, .provisional:
                completion(true)
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) {
                    ok, err in
                    
                    if let err = err {
                        print("\(err)")
                        return
                    }
                    
                    completion(ok)
                }
            default:
                fatalError("Status não identificado")
            }
        }
    }
    
    func showNotification(sender: String) {
        let content = UNMutableNotificationContent()
        
        if let name = selectedRestaurant?.name {
            content.title = name
        }
        
        content.subtitle = "Reserva de Restaurante"
        content.body = "Mesa para 2, hoje às \(sender)"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "comerNaRuaReserva"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func unwindReviewCancel(segue: UIStoryboardSegue) {}
}
