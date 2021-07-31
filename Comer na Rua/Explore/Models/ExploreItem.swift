//
//  ExploreItem.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import Foundation

struct ExploreItem {
    var name: String
    var image: String
}

extension ExploreItem {
    init(dict: [String:AnyObject]) {
        self.name = dict["name"] as! String
        self.image = dict["image"] as! String
    }
}
