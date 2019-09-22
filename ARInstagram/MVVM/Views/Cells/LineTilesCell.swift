//
//  TileLayoutCell.swift
//  ARAlbum
//
//  Created by nativ levy on 10/06/2019.
//

import Foundation
import UIKit

class LineTilesCell: UICollectionViewCell, CopyableCell {
    
    static let cellHeight: CGFloat = 150

    @IBOutlet weak var image1: ClassicFramedImage!
    @IBOutlet weak var image2: ClassicFramedImage!
    @IBOutlet weak var image3: ClassicFramedImage!
    
    func copyCell() -> CopyableCell {
        
        let cell = loadNib() as! LineTilesCell
        cell.frame = frame
        cell.image1.iv.image = image1.iv.image
        cell.image2.iv.image = image2.iv.image
        cell.image3.iv.image = image3.iv.image
        return cell
    }
    
    func initSetup() {
        
        image1.iv.image = UIImage(named: "image1")
        image2.iv.image = UIImage(named: "image2")
        image3.iv.image = UIImage(named: "image3")
    }
    
    func set(images: [UIImage?]) {
        if images.count > 0 {
            image1.iv.contentMode = .scaleAspectFill
            image1.iv.image = images[0]
        }
        if images.count > 1 {
            image2.iv.contentMode = .scaleAspectFill
            image2.iv.image = images[1]
        }
        if images.count > 2 {
            image3.iv.contentMode = .scaleAspectFill
            image3.iv.image = images[2]
        }
    }
}
