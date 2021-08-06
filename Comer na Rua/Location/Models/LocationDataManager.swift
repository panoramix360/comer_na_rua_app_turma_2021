//
//  LocationDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import Foundation

class LocationDataManager: DataManager {
    fileprivate var locations: [LocationItem] = []
    
    func fetch() {
        for location in load(file: "LocationsData") {
            locations.append(LocationItem(dict: location))
        }
    }
    
    func numberOfItems() -> Int {
        return locations.count
    }
    
    func locationItem(at index: IndexPath) -> LocationItem {
        return locations[index.item]
    }
}
