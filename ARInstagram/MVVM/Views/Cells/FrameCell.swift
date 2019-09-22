//
//  PhotoAlbumCell.swift
//  sample-instagram
//
//  Created by admin on 2017/12/08.
//  Copyright © 2017 i05nagai. All rights reserved.
//

import Foundation
import UIKit

class FrameCell: UICollectionViewCell {
    
    @IBOutlet weak var frameImage: UIImageView!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var smallContentImage: UIImageView!
    @IBOutlet weak var frameName: UILabel!
    
    var frameType: TileNode.Frames?
    
    var representedAssetIdentifier: String!
    var hasBorder = false {
        didSet {
            hasBorder ? frameImage.showBorder() : frameImage.removeBorder()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        frameImage.image = nil
        contentImage.image = nil
        smallContentImage.image = nil
        frameName.text = nil
        removeBorder()
    }
    
    func setup(item number: Int, image: UIImage, frameImage: UIImage) {
        
        frameType = TileNode.Frames.build(from: number)
        self.frameImage.image = frameImage
        switch number {
        case 0:
            frameName.text = "Clean"
            contentImage.isHidden = false
            contentImage.image = image
            smallContentImage.isHidden = true
        case 1:
            frameName.text = "Classic"
            contentImage.isHidden = true
            smallContentImage.isHidden = false
            smallContentImage.image = image
        case 2:
            frameName.text = "Ever"
            contentImage.isHidden = true
            smallContentImage.isHidden = false
            smallContentImage.image = image
        case 3:
            frameName.text = "Bold"
            contentImage.isHidden = false
            contentImage.image = image
            smallContentImage.isHidden = true
        default:
            break
        }
    }
    
}
