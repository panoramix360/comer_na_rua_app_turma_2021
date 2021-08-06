//
//  RestaurantAPIManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import Foundation

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
    
    func fetchRestaurants(completion: @escaping (Result<[RestaurantItem], Error>) -> Void) {
        let url = APIManager.restaurantsURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processRestaurantsRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    private func processRestaurantsRequest(data: Data?, error: Error?) -> Result<[RestaurantItem], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return APIManager.restaurants(fromJSON: jsonData)
    }
}
