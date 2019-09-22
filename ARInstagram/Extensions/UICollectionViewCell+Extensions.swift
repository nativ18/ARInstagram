//
//  UICollectionCellView.swift
//  ARAlbum
//
 //  Created by nativ levy on 11/06/2019.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
