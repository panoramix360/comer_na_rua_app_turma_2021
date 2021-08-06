//
//  RestaurantDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import Foundation

class RestaurantDataManager {
    fileprivate var items: [RestaurantItem] = []
    
    func fetch(withCuisines filter: String = "Todas") {
        RestaurantAPIManager.shared.fetchRestaurants {
            (restaurautsResult) in
            
            switch restaurautsResult {
            case let .success(restaurants):
                if filter != "Todas" {
                    self.items = restaurants.filter { $0.cuisines.contains(filter) }
                } else {
                    self.items = restaurants
                }
            case let .failure(error):
                print("Erro ao buscar restaurantes: \(error)")
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
