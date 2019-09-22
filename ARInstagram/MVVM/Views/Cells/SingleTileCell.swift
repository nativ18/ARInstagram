//
//  TileLayoutCell.swift
//  ARAlbum
//
//  Created by nativ levy on 10/06/2019.
//

import Foundation
import UIKit

class SingleTileCell: UICollectionViewCell, CopyableCell  {
    
    static let cellHeight: CGFloat = 150
    
    @IBOutlet weak var classicFrame: ClassicFramedImage!
    
    func copyCell() -> CopyableCell {
        
        let cell = loadNib() as! SingleTileCell
        cell.frame = frame
        cell.classicFrame.iv.image = classicFrame.iv.image
        return cell
    }
    
    func initSetup() {
        
        classicFrame.iv.image = UIImage(named: "image1")
    }
    
    func set(image: UIImage) {
        
        classicFrame.iv.image = image
    }
}
