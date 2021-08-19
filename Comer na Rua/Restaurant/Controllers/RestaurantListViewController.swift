//
//  RestaurantListViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 29/07/21.
//

import UIKit

class RestaurantListViewController: UIViewController {
    
    @IBOutlet var restaurantListCollectionView: UICollectionView!
    
    let manager = RestaurantDataManager()
    var selectedLocation: LocationItem?
    var selectedCuisine: String?
    
    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadRestaurants()
    }
}

// MARK: - Private extension
private extension RestaurantListViewController {
    func loadRestaurants() {
        guard let city = selectedLocation?.city,
              let state = selectedLocation?.state,
              let cuisine = selectedCuisine else {
            return
        }
        
        manager.fetch(by: RestaurantFilter(city: city, state: state, cuisine: cuisine)) {
            _ in
            
            if self.manager.numberOfItems() > 0 {
                self.restaurantListCollectionView.backgroundView = nil
            } else {
                let view = NoDataView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: self.restaurantListCollectionView.frame.width,
                                                    height: self.restaurantListCollectionView.frame.height))
                view.set(title: "Restaurantes")
                view.set(desc: "Nenhum restaurante encontrado.")
                self.restaurantListCollectionView.backgroundView = view
            }
            
            self.restaurantListCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RestaurantListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! RestaurantCell
        
        let item = manager.restaurantItem(at: indexPath)
        
        if let name = item.name { cell.titleLabel.text = name }
        if let cuisine = item.subtitle { cell.cuisineLabel.text = cuisine }
        
        if let image = item.imageURL,
           let url = URL(string: image) {
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                cell.restaurantImage.image = UIImage(data: imageData)
            }
            
        }
        
        return cell
    }
}
