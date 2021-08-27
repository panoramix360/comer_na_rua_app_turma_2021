//
//  FilterItem.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 26/08/21.
//

import Foundation

class FilterItem: NSObject {
    let filter: String
    let name: String
    
    init(dict: [String:AnyObject]) {
        self.filter = dict["filter"] as! String
        self.name = dict["name"] as! String
    }
}
