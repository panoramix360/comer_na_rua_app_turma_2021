//
//  RestaurantPhotoItem.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 26/08/21.
//

import UIKit

struct RestaurantPhotoItem {
    var photo: UIImage?
    var date: Date?
    var restaurantID: Int?
    var uuid = UUID()
    
    var photoData: Data {
        guard let image = photo else {
            return Data()
        }
        
        return Data(image.pngData()!)
    }
}

extension RestaurantPhotoItem {
    init(restaurantPhoto: RestaurantPhoto) {
        self.restaurantID = Int(restaurantPhoto.restaurantID)
        
        if let restaurantPhoto = restaurantPhoto.photo {
            self.photo = UIImage(data: restaurantPhoto, scale: 1.0)
        }
        
        if let uuid = restaurantPhoto.uuid {
            self.uuid = uuid
        }
        
        if let reviewDate = restaurantPhoto.date {
            self.date = reviewDate
        }
    }
}
