//
//  RestaurantListViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 29/07/21.
//

import UIKit

class RestaurantListViewController: UIViewController {
    
    @IBOutlet var restaurantListCollectionView: UICollectionView!
    
    var selectedLocation: LocationItem?
    var selectedCuisine: String?
    
    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let city = selectedLocation?.city,
              let state = selectedLocation?.state,
              let cuisine = selectedCuisine else {
            return
        }
        
        let manager = RestaurantDataManager()
        manager.fetch(by: RestaurantFilter(city: city, state: state, cuisine: cuisine)) {
            items in
            
            if manager.numberOfItems() > 0 {
                for item in items {
                    print(item.name)
                }
            } else {
                print("Nenhum restaurante encontrado")
            }
        }
    }
}

// MARK: - Private extension
private extension RestaurantListViewController {
    
}

// MARK: - UICollectionViewDataSource
extension RestaurantListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath)
    }
}
