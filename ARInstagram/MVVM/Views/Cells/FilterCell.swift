//
//  FilterCell.swift
//  sample-instagram
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017 i05nagai. All rights reserved.
//

import Foundation
import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var hasBorder = false {
        didSet {
            hasBorder ? showBorder() : removeBorder()
        }
    }
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        removeBorder()
    }
}
