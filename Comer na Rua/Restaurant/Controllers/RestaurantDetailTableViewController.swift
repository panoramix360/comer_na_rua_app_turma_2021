//
//  RestaurantDetailTableViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 05/08/21.
//

import UIKit
import MapKit

class RestaurantDetailTableViewController: UITableViewController {
    
    // Célula 01
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cuisinesLabel: UILabel!
    @IBOutlet var headerAddressLabel: UILabel!
    
    // Célula 02
    @IBOutlet var tableDetailsLabel: UILabel!
    
    // Célula 03
    @IBOutlet var addressLabel: UILabel!
    
    // Célula 04
    @IBOutlet var mapAddressImage: UIImageView!
    
    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dump(selectedRestaurant as Any)
    }
    
    @IBAction func onHeartTapped(_ sender: UIBarButtonItem) {
    }
}
