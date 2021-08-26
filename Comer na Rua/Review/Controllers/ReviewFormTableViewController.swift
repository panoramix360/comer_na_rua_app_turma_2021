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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSaveTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
