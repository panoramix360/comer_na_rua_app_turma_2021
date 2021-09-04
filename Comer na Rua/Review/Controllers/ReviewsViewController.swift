//
//  ReviewsViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 04/09/21.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var selectedRestaurantID: Int?
    
    var reviews = [ReviewItem]()
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkReviews()
    }
}

// MARK: - Private Extension
private extension ReviewsViewController {
    func initialize() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let flow = UICollectionViewFlowLayout()
        
        flow.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 7
        flow.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = flow
    }
    
    func checkReviews() {
        let viewController = self.parent as? RestaurantDetailTableViewController
        
        if let id = viewController?.selectedRestaurant?.restaurantID {
            reviews = CoreDataManager.shared.fetchReview(by: id)
            
            if reviews.isEmpty {
                let view = NoDataView(frame: CGRect(x: 0, y: 0,
                                                    width: collectionView.frame.width,
                                                    height: collectionView.frame.height))
                
                view.set(title: "Avaliações")
                view.set(desc: "Ainda não existem avaliações")
                collectionView.backgroundView = view
            } else {
                collectionView.backgroundView = nil
            }
            
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        
        let item = reviews[indexPath.item]
        
        cell.nameLabel.text = item.name
        cell.titleLabel.text = item.title
        cell.reviewLabel.text = item.customerReview
        
        if let date = item.date {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let rating = item.rating {
            cell.ratingsView.rating = Double(rating)
            cell.ratingsView.isEnabled = false
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var margin = 21
        
        if reviews.count == 1 {
            margin = 14
        }
        
        return CGSize(width: collectionView.frame.size.width + CGFloat(margin), height: 200)
    }
}
