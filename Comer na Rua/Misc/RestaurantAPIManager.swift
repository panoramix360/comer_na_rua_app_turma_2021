//
//  RestaurantAPIManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import Foundation
import UIKit

enum RestaurantAPIFilterKeys: String {
    case city = "cidade"
    case state = "estado"
}

enum RestaurantImageError: Error {
    case imageCreationError
    case missingImageURL
}

class RestaurantAPIManager {
    static let shared: RestaurantAPIManager = {
        let instance = RestaurantAPIManager()
        return instance
    }()
    
    private init() {}
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchRestaurants(by filter: RestaurantFilter, completion: @escaping (Result<[RestaurantItem], Error>) -> Void) {
        let url = APIManager.restaurantsURL(with: filterToDict(filter))
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processRestaurantsRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    func fetchRestaurantImage(for restaurant: RestaurantItem, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let imagePath = restaurant.imageURL,
              let imageURL = URL(string: imagePath) else {
            completion(.failure(RestaurantImageError.missingImageURL))
            return
        }
        let request = URLRequest(url: imageURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processRestaurantImageRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    private func processRestaurantImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard let imageData = data,
              let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(RestaurantImageError.imageCreationError)
            }
        }
        
        return .success(image)
    }
    
    private func processRestaurantsRequest(data: Data?, error: Error?) -> Result<[RestaurantItem], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return APIManager.restaurants(fromJSON: jsonData)
    }
    
    private func filterToDict(_ filter: RestaurantFilter) -> [String:String] {
        return [
            RestaurantAPIFilterKeys.city.rawValue: filter.city,
            RestaurantAPIFilterKeys.state.rawValue: filter.state
        ]
    }
}
