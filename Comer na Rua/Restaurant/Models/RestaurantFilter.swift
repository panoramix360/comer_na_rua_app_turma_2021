//
//  RestaurantFilter.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 12/08/21.
//

import Foundation

struct RestaurantFilter {
    let city: String
    let state: String
    let cuisine: String?
    
    init(city: String, state: String, cuisine: String? = nil) {
        self.city = city
        self.state = state
        self.cuisine = cuisine
    }
}
