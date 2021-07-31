//
//  RestaurantListViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 29/07/21.
//

import UIKit

class RestaurantListViewController: UIViewController {
    
    @IBOutlet var restaurantListCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
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
