//
//  LocationItem.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import Foundation

struct LocationItem {
    var city: String?
    var state: String?
}

extension LocationItem {
    init(dict: [String:AnyObject]) {
        self.city = dict["city"] as? String
        self.state = dict["state"] as? String
    }
    
    var full: String {
        guard let city = city,
              let state = state else {
            return ""
        }
        
        return "\(city), \(state)"
    }
}
