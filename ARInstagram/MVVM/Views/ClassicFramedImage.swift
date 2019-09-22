//
//  ClassicFramedImage.swift
//  ARAlbum
//
//  Created by nativ levy on 14/06/2019.
//

import Foundation
import UIKit

class ClassicFramedImage: UIView {
    
    var fv: UIImageView!
    var iv: UIImageView!
    
    override var center: CGPoint {
        didSet {
            iv.center = convert(center, from: superview)
            fv.center = convert(center, from: superview)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {

        let itemWidth = UIScreen.main.bounds.width  * 3/10
        constraints.forEach{
            if $0.firstAttribute == .width || $0.firstAttribute == .height{
                $0.constant = itemWidth
            }
        }
        frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth)
        fv = UIImageView(image: UIImage(named: "classic"))
        fv.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth)
        fv.center = convert(center, from: superview)
        addSubview(fv)
        iv = UIImageView(frame: CGRect(x: 0, y: 0, width: itemWidth - 10, height: itemWidth - 10))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        addSubview(iv)
    }
}
