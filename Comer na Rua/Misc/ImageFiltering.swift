//
//  ImageFiltering.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 26/08/21.
//

import UIKit
import CoreImage

protocol ImageFiltering {
    func apply(filter: String, originalImage: UIImage) -> UIImage
}

extension ImageFiltering {
    func apply(filter: String, originalImage: UIImage) -> UIImage {
        let initialCIImage = CIImage(image: originalImage, options: nil)
        let originalOrientation = originalImage.imageOrientation
        
        guard let ciFilter = CIFilter(name: filter) else {
            print("filter não encontrado")
            return originalImage
        }
        
        ciFilter.setValue(initialCIImage, forKey: kCIInputImageKey)
        
        let context = CIContext()
        let filteredCIImage = (ciFilter.outputImage)!
        let filteredCGImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)
        
        return UIImage(cgImage: filteredCGImage!, scale: 1.0, orientation: originalOrientation)
    }
}
