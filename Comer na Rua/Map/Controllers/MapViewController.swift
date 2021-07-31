//
//  MapViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    let manager = MapDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    func initialize() {
        manager.fetch { addMapAnnotations($0) }
    }
    
    func addMapAnnotations(_ annotations: [RestaurantItem]) {
        mapView.setRegion(manager.currentRegion(latDelta: 0.5, longDelta: 0.5), animated: true)
        mapView.addAnnotations(annotations)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let identifier = "custompin"
        
        var annotationView: MKAnnotationView?
        
        if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            // se a anotação a ser exibida já foi criada, estamos pegando ela do pool de anotações
            annotationView = customAnnotationView
            annotationView?.annotation = annotation
        } else {
            // se a anotação com o nosso identifier não existir no pool de anotações iremos criar uma do zero
            let newAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            newAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = newAnnotationView
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "custom-annotation")
        }
        
        return annotationView
    }
}
