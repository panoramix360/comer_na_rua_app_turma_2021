//
//  MapDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import Foundation

class MapDataManager {
    fileprivate var items: [RestaurantItem] = []
    
    var annotations: [RestaurantItem] {
        return items
    }
    
    func fetch(completion: (_ annotations: [RestaurantItem]) -> ()) {
        if items.count > 0 { items.removeAll() }
        
        for data in loadData() {
            items.append(RestaurantItem(dict: data))
        }
        
        completion(items)
    }
    
    fileprivate func loadData() -> [[String:AnyObject]] {
        guard let path = Bundle.main.path(forResource: "MapLocationsData", ofType: "plist"),
              let items = NSArray(contentsOfFile: path) else {
            return [[:]]
        }
        
        return items as! [[String:AnyObject]]
    }
}
