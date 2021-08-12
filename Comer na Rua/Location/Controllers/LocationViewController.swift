//
//  LocationViewController.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 31/07/21.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet var locationTableView: UITableView!
    
    let manager = LocationDataManager()
    var selectedLocation: LocationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private extension
private extension LocationViewController {
    func initialize() {
        manager.fetch()
    }
}

// MARK: - UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        cell.textLabel?.text = manager.locationItem(at: indexPath).full
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedLocation = manager.locationItem(at: indexPath)
            tableView.reloadData()
        }
    }
}
