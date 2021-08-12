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
    
    func findLocation(by name: String) -> (isFound: Bool, position: Int) {
        guard let index = locations.firstIndex(where: { $0.city == name }) else {
            return (isFound: false, position: 0)
        }
        
        return (isFound: true, position: index)
    }
    
    func numberOfItems() -> Int {
        return locations.count
    }
    
    func locationItem(at index: IndexPath) -> LocationItem {
        return locations[index.item]
    }
}
