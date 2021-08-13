//
//  MapDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import Foundation
import MapKit

class MapDataManager: DataManager {
    fileprivate var items: [RestaurantItem] = []
    
    var annotations: [RestaurantItem] {
        return items
    }
    
    func fetch(completion: @escaping (_ annotations: [RestaurantItem]) -> ()) {
        let manager = RestaurantDataManager()
        manager.fetch(by: RestaurantFilter(city: "Rio de Janeiro", state: "RJ")) {
            items in
            
            self.items = items
            completion(items)
        }
    }
    
    func currentRegion(latDelta: CLLocationDegrees, longDelta: CLLocationDegrees) -> MKCoordinateRegion {
        guard let item = items.first else {
            return MKCoordinateRegion()
        }
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        return MKCoordinateRegion(center: item.coordinate, span: span)
    }
}
