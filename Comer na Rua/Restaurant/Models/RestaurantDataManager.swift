//
//  RestaurantDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import Foundation
import UIKit

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
    
    func fetchImage(at index: IndexPath, completion: @escaping (_ image: UIImage) -> Void) {
        RestaurantAPIManager.shared.fetchRestaurantImage(for: items[index.item]) {
            (imageResult) in
            
            switch imageResult {
            case let .success(image):
                DispatchQueue.main.async {
                    completion(image)
                }
            case let .failure(error):
                print("Não foi possível baixar a imagem: \(error)")
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
