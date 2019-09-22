//
//  UIImage+Extensions.swift
//  ARAlbum
//
//  Created by nativ levy on 09/06/2019.
//

import Foundation
import UIKit

extension UIImage {
    
    func cropImageToSquare() -> UIImage? {
        var imageHeight = size.height
        var imageWidth = size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(cgImage!.width)
        let refHeight : CGFloat = CGFloat(cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: imageOrientation)
        }
        
        return nil
    }

}
