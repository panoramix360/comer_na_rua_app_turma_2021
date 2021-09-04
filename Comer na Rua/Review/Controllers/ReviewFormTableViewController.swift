//
//  ReviewFormTableViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 26/08/21.
//

import UIKit

class ReviewFormTableViewController: UITableViewController {

    @IBOutlet var ratingsView: RatingsView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var reviewTextView: UITextView!
    
    var selectedRestaurantID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedRestaurantID)
    }

    @IBAction func onSaveTapped(_ sender: UIBarButtonItem) {
        var item = ReviewItem()
        item.title = titleTextField.text
        item.name = nameTextField.text
        item.customerReview = reviewTextView.text
        item.restaurantID = selectedRestaurantID
        item.rating = ratingsView.rating
        
        CoreDataManager.shared.addReview(item)
        
        dismiss(animated: true, completion: nil)
    }
}
