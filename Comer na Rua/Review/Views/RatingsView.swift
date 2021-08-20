//
//  RatingsView.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 19/08/21.
//

import UIKit

class RatingsView: UIControl {
    
    private let filledStarImage = #imageLiteral(resourceName: "filled-star")
    private let halfStarImage = #imageLiteral(resourceName: "half-star")
    private let emptyStarImage = #imageLiteral(resourceName: "empty-star")
    
    var rating = 0.0
    var totalStars = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.fill(rect)
        
        let availableWidth = rect.size.width // 200
        let cellWidth = availableWidth / CGFloat(totalStars) // 40
        let starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height
        
        for index in 0...totalStars {
            let valueX = cellWidth * CGFloat(index) + cellWidth / 2
            let center = CGPoint(x: valueX + 1, y: rect.size.height / 2)
            
            let frame = CGRect(x: center.x - starSide / 2, y: center.y - starSide / 2, width: starSide, height: starSide)
            
            let filled = (Double(index + 1) <= self.rating.rounded(.up))
            
            if filled && (Double(index + 1) > self.rating) {
                drawHalfStar(with: frame)
            } else {
                drawStar(with: frame, filled: filled)
            }
        }
        
    }
}

// MARK: - Private Extension
private extension RatingsView {
    func drawStar(with frame: CGRect, filled: Bool) {
        let image = filled ? filledStarImage : emptyStarImage
        draw(with: image, and: frame)
    }
    
    func drawHalfStar(with frame: CGRect) {
        draw(with: halfStarImage, and: frame)
    }
    
    func draw(with image: UIImage, and frame: CGRect) {
        image.draw(in: frame)
    }
}
