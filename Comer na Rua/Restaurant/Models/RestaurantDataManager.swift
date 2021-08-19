//
//  RestaurantDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import Foundation

class RestaurantDataManager {
    fileprivate var items: [RestaurantItem] = []
    
    func fetch(by filter: RestaurantFilter, completion: @escaping (_ items: [RestaurantItem]) -> Void) {
        RestaurantAPIManager.shared.fetchRestaurants(by: filter) {
            (restaurautsResult) in
            
            switch restaurautsResult {
            case let .success(restaurants):
                if let cuisine = filter.cuisine,
                   cuisine != "Todas" {
                    self.items = restaurants.filter { $0.cuisines.contains(cuisine) }
                } else {
                    self.items = restaurants
                }
            case let .failure(error):
                print("Erro ao buscar restaurantes: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(self.items)
            }
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func restaurantItem(at index: IndexPath) -> RestaurantItem {
        return items[index.item]
    }
}
