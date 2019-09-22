//
//  TileLayoutCell.swift
//  ARAlbum
//
//  Created by nativ levy on 10/06/2019.
//

import Foundation
import UIKit

protocol CopyableCell: UICollectionViewCell {
    func copyCell() -> CopyableCell
    func initSetup()
}

class PyramidTilesCell: UICollectionViewCell, CopyableCell {
    
    public static let cellHeight: CGFloat = 402

    @IBOutlet weak var level1Image1: ClassicFramedImage!
    @IBOutlet weak var level1Image2: ClassicFramedImage!
    @IBOutlet weak var level1Image3: ClassicFramedImage!
    @IBOutlet weak var level2Image1: ClassicFramedImage!
    @IBOutlet weak var level2Image2: ClassicFramedImage!
    @IBOutlet weak var level3Image1: ClassicFramedImage!
    
    func copyCell() -> CopyableCell {
        
        let cell = loadNib() as! PyramidTilesCell
        cell.frame = frame
        cell.level1Image1.iv.image = level1Image1.iv.image
        cell.level1Image2.iv.image = level1Image2.iv.image
        cell.level1Image3.iv.image = level1Image3.iv.image
        cell.level2Image1.iv.image = level2Image1.iv.image
        cell.level2Image2.iv.image = level2Image2.iv.image
        cell.level3Image1.iv.image = level3Image1.iv.image
        return cell
    }
    
    func initSetup() {
        
        level1Image1.iv.image = UIImage(named: "image1")
        level1Image2.iv.image = UIImage(named: "image2")
        level1Image3.iv.image = UIImage(named: "image3")
        level2Image1.iv.image = UIImage(named: "image3")
        level2Image2.iv.image = UIImage(named: "image4")
        level3Image1.iv.image = UIImage(named: "image5")
    }
    
    func set(images: [UIImage?]) {
        
        if images.count > 0 {
            level1Image1.iv.contentMode = .scaleAspectFill
            level1Image1.iv.image = images[0]
        }
        if images.count > 1 {
            level1Image2.iv.contentMode = .scaleAspectFill
            level1Image2.iv.image = images[1]
        }
        if images.count > 2 {
            level1Image3.iv.contentMode = .scaleAspectFill
            level1Image3.iv.image = images[2]
        }
        if images.count > 3 {
            level2Image1.iv.contentMode = .scaleAspectFill
            level2Image1.iv.image = images[3]
        }
        if images.count > 4 {
            level2Image2.iv.contentMode = .scaleAspectFill
            level2Image2.iv.image = images[4]
        }
        if images.count > 5 {
            level3Image1.iv.contentMode = .scaleAspectFill
            level3Image1.iv.image = images[5]
        }
    }
}
