//
//  RestaurantItem.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import UIKit
import MapKit

class RestaurantItem: NSObject, MKAnnotation, Codable {
    var name: String?
    var cuisines: [String] = []
    var lat: Double?
    var long: Double?
    var address: String?
    var postalCode: String?
    var state: String?
    var imageURL: String?
    var restaurantID: Int?
    
    var coordinate: CLLocationCoordinate2D {
        guard let lat = lat,
              let long = long else {
            return CLLocationCoordinate2D()
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        if cuisines.isEmpty { return "" }
        else if cuisines.count == 1 { return cuisines.first }
        else { return cuisines.joined(separator: ", ") }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "nome"
        case cuisines = "cozinhas"
        case lat
        case long
        case address = "endereco"
        case postalCode = "cep"
        case state = "estado"
        case imageURL = "image_url"
        case restaurantID = "id"
    }
}
