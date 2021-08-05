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
    
    static var restaurantsURL: URL {
        return apiURL(endpoint: .restaurants)
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
