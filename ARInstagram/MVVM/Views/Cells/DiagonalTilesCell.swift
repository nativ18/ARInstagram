//
//  TileLayoutCell.swift
//  ARAlbum
//
//  Created by nativ levy on 10/06/2019.
//

import Foundation
import UIKit

class DiagonalTilesCell: UICollectionViewCell, CopyableCell {
    
    public static let cellHeight: CGFloat = 252
    
    @IBOutlet weak var frame1: ClassicFramedImage!
    @IBOutlet weak var frame2: ClassicFramedImage!
    @IBOutlet weak var frame3: ClassicFramedImage!
    
    func copyCell() -> CopyableCell {
        
        let cell = loadNib() as! DiagonalTilesCell
        cell.frame = frame
        cell.frame1.iv.image = frame1.iv.image
        cell.frame2.iv.image = frame2.iv.image
        cell.frame3.iv.image = frame3.iv.image
        return cell
    }
    
    func initSetup() {
        
        frame1.iv.image = UIImage(named: "image1")
        frame2.iv.image = UIImage(named: "image2")
        frame3.iv.image = UIImage(named: "image3")
    }
    
    func set(images: [UIImage?]) {
        if images.count > 0 {
            frame1.contentMode = .scaleAspectFill
            frame1.iv.image = images[0]
        }
        if images.count > 1 {
            frame2.iv.contentMode = .scaleAspectFill
            frame2.iv.image = images[1]
        }
        if images.count > 2 {
            frame3.iv.contentMode = .scaleAspectFill
            frame3.iv.image = images[2]
        }
    }
}
