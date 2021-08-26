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
    
    @IBOutlet var ratingsView: RatingsView!
    
    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    @IBAction func onHeartTapped(_ sender: UIBarButtonItem) {
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
        ratingsView.rating = 3.5
        ratingsView.isEnabled = true
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
}
