//
//  LocationDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import Foundation

class LocationDataManager {
    fileprivate var locations: [String] = []
    
    func fetch() {
        for location in loadData() {
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
    
    fileprivate func loadData() -> [[String:AnyObject]] {
        guard let path = Bundle.main.path(forResource: "LocationsData", ofType: "plist"),
              let items = NSArray(contentsOfFile: path) else {
            return [[:]]
        }
        
        return items as! [[String:AnyObject]]
    }
}
