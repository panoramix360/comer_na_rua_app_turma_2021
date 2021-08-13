//
//  APIManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import Foundation

enum Endpoint: String {
    case restaurants = "/panoramix360/aula_ios_api/restaurants"
}

struct APIManager {
    private static let baseURL: String = "http://my-json-server.typicode.com"
    
    static func restaurantsURL(with filter: [String:String]?) -> URL {
        return apiURL(endpoint: .restaurants, parameters: filter)
    }
    
    static func restaurants(fromJSON data: Data) -> Result<[RestaurantItem], Error> {
        do {
            let decoder = JSONDecoder()
            let restaurantsResponse = try decoder.decode([RestaurantItem].self, from: data)
            return .success(restaurantsResponse)
        } catch {
            return .failure(error)
        }
    }
    
    private static func apiURL(endpoint: Endpoint, parameters: [String:String]? = nil) -> URL {
        var components = URLComponents(string: baseURL)!
        components.path = endpoint.rawValue
        
        if let additionalParams = parameters {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
            components.queryItems = queryItems
        }
        
        return components.url!
    }
}
