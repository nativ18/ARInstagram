//
//  ARViewController+Gallery.swift
//  ARAlbum
//
//  Created by nativ levy on 10/06/2019

import Foundation
import UIKit
import PhotosUI
import Gallery
import Lightbox
import SVProgressHUD

extension TilesLayoutViewController: GalleryControllerDelegate, LightboxControllerDismissalDelegate {
    
    //    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
    //        controller.dismiss(animated: true, completion: nil)
    //        images[0].resolve { [weak self] image in
    //            guard let self = self else { return }
    //            self.image = image
    //            self.setupScene()
    //            self.selectPhotoLabel.isHidden = true
    //            self.applyFilters()
    //
    //            self.filtersCollectionView.reloadData()
    //            self.filtersTapped(self)
    //        }
    //    }
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        //controller.dismiss(animated: true, completion: nil)
        
        Image.resolve(images: images) { [weak self ] uiimages in
            self?.processImages(images: uiimages)
        }
    }
    
    func processImages(images: [UIImage?]) {
        
        self.selectedImages = images
        
        switch topSelectedCellItem {
        case is SingleTileCell:
            if let image = images[0] {
                (topSelectedCellItem as? SingleTileCell)?.set(image: image)
            }
            if images.count == 1 {
                if barButton.isEnabled {
                    goARTapped(barButton)
                }
                barButton.isEnabled = true
            }
        case is LineTilesCell:
            (topSelectedCellItem as? LineTilesCell)?.set(images: images)
            if images.count == 3 {
                if barButton.isEnabled {
                    goARTapped(barButton)
                }
                barButton.isEnabled = true
            }
        case is ColumnsTilesCell:
            (topSelectedCellItem as? ColumnsTilesCell)?.set(images: images)
            if images.count == 3 {
                if barButton.isEnabled {
                    goARTapped(barButton)
                }
                barButton.isEnabled = true
            }
        case is DiagonalTilesCell:
            (topSelectedCellItem as? DiagonalTilesCell)?.set(images: images)
            if images.count == 3 {
                if barButton.isEnabled {
                    goARTapped(barButton)
                }
                barButton.isEnabled = true
            }
        case is PyramidTilesCell:
            (topSelectedCellItem as? PyramidTilesCell)?.set(images: images)
            if images.count == 6 {
                if barButton.isEnabled {
                    goARTapped(barButton)
                }
                barButton.isEnabled = true
            }
        default:
            break
        }
    }
    
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        LightboxConfig.DeleteButton.enabled = true
        
        SVProgressHUD.show()
        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            SVProgressHUD.dismiss()
            self?.showLightbox(images: resolvedImages.compactMap({ $0 }))
        })
    }
    
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        gallery?.dismiss(animated: true)
        topSelectedCellItem?.removeFromSuperview()
        blockingWhiteView?.alpha = 0
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        gallery?.dismiss(animated: true)
        topSelectedCellItem?.removeFromSuperview()
        blockingWhiteView?.alpha = 0
    }
    
    // MARK: - Helper
    
    func showLightbox(images: [UIImage]) {
        guard images.count > 0 else {
            return
        }
        
        let lightboxImages = images.map({ LightboxImage(image: $0) })
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dismissalDelegate = self
        
        gallery?.present(lightbox, animated: true, completion: nil)
    }
}
