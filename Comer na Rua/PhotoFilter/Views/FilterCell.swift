//
//  FilterCell.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 26/08/21.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var thumbImage: UIImageView!
}

extension FilterCell: ImageFiltering {
    func set(image: UIImage, item: FilterItem) {
        if item.filter != "None" {
            let filteredImg = apply(filter: item.filter, originalImage: image)
            thumbImage.image = filteredImg
        } else {
            thumbImage.image = image
        }
        
        nameLabel.text = item.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImage.layer.cornerRadius = 9
        thumbImage.layer.masksToBounds = true
    }
}
