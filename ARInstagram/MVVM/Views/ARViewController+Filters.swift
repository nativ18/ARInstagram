//
//  ARViewController+Filters.swift
//  ARAlbum
//
 //  Created by nativ levy on 11/06/2019.
//

import Foundation
import UIKit

extension ARViewController {
    
    func applyFilter(
        applier: FilterApplierType?, ciImage: CIImage) -> UIImage {
        let outputImage: CIImage? = applier!(ciImage)
        
        let outputCGImage = self.ciContext.createCGImage(
            (outputImage)!,
            from: (outputImage?.extent)!)
        return UIImage(cgImage: outputCGImage!)
    }
    
    func applyFilter(
        applier: FilterApplierType?, image: UIImage) -> UIImage {
        let ciImage: CIImage? = CIImage(image: image)
        return applyFilter(applier: applier, ciImage: ciImage!)
    }
    
    func applyFilter(at: Int, image: UIImage) -> UIImage {
        let applier: FilterApplierType? = self.filters[at].applier
        return applyFilter(applier: applier, image: image)
    }
    
    func applyFilters(image: UIImage) {
        
        self.thumbnailImages = filters.map({ (name, applier) -> UIImage in
            if applier == nil {
                return image
            }
            let uiImage = self.applyFilter(
                applier: applier,
                ciImage: CIImage(cgImage: image.cgImage!))
            return uiImage
        })
    }
}
