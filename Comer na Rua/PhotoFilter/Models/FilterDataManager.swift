//
//  FilterDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 26/08/21.
//

import Foundation

class FilterDataManager: DataManager {
    fileprivate var items: [FilterItem] = []
    
    func fetch(completion: (_ items: [FilterItem]) -> Void) {
        for data in load(file: "FilterData") {
            items.append(FilterItem(dict: data))
        }
        
        completion(items)
    }
}
