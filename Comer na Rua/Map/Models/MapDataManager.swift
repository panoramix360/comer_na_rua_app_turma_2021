//
//  MapDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import Foundation

class MapDataManager: DataManager {
    fileprivate var items: [RestaurantItem] = []
    
    var annotations: [RestaurantItem] {
        return items
    }
    
    func fetch(completion: (_ annotations: [RestaurantItem]) -> ()) {
        if items.count > 0 { items.removeAll() }
        
        for data in load(file: "MapLocationsData") {
            items.append(RestaurantItem(dict: data))
        }
        
        completion(items)
    }
}
