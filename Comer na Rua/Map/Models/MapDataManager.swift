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
        RestaurantAPIManager.shared.fetchRestaurants {
            (restaurautsResult) in
            
            switch restaurautsResult {
            case let .success(restaurants):
                self.items = restaurants
                completion(restaurants)
            case let .failure(error):
                print("Erro ao buscar restaurantes: \(error)")
            }
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
