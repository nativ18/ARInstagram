//
//  UIViewController+Extensions.swift
//  ARAlbum
//
//  Created by nativ levy on 07/06/2019.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showARViewController(images: [UIImage], tilesType: ARViewController.TileNodeType) {
        
        let vc: ARViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
        vc.images = images
        vc.tilesNodeType = tilesType
        navigationController?.pushViewController(vc, animated: true)
    }
}
