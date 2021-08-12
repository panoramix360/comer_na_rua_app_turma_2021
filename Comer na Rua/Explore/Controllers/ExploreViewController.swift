//
//  ExploreViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 29/07/21.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet var categoriesCollectionView: UICollectionView!
    var headerView: ExploreHeaderView!
    
    let manager = ExploreDataManager()
    var selectedLocation: LocationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private Extension
private extension ExploreViewController {
    func initialize() {
        manager.fetch()
    }
    
    @IBAction func unwindLocationCancel(segue: UIStoryboardSegue) {}
    
    @IBAction func unwindLocationDone(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? LocationViewController {
            selectedLocation = viewController.selectedLocation
            
            if let location = selectedLocation {
                headerView.locationLabel.text = location.full
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as! ExploreCollectionViewCell
        
        let item = manager.explore(at: indexPath)
        
        cell.nameLabel.text = item.name
        cell.exploreImageView.image = UIImage(named: item.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        headerView = header as? ExploreHeaderView
        
        return header
    }
}
