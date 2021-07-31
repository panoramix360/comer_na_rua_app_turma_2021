//
//  LocationDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import Foundation

class LocationDataManager: DataManager {
    fileprivate var locations: [String] = []
    
    func fetch() {
        for location in load(file: "LocationsData") {
            if let city = location["city"] as? String,
               let state = location["state"] as? String {
                locations.append("\(city), \(state)")
            }
        }
    }
    
    func numberOfItems() -> Int {
        return locations.count
    }
    
    func locationItem(at index: IndexPath) -> String {
        return locations[index.item]
    }
}
