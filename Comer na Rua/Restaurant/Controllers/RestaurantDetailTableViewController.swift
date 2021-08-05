//
//  RestaurantDetailTableViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import UIKit

class RestaurantDetailTableViewController: UITableViewController {
    
    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dump(selectedRestaurant as Any)
    }
}
