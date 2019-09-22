//
//  ARViewController+CollectionView.swift
//  ARAlbum
//
//  Created by nativ levy on 10/06/2019.
//

import Foundation
import UIKit

extension ARViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filtersCollectionView {
            return thumbnailImages.count
        } else {
            return framesImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filtersCollectionView {
            guard let cell: FilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCell.self), for: indexPath) as? FilterCell else {
                fatalError("unexpected cell in collection view")
            }
            cell.thumbnailImage = self.thumbnailImages[indexPath.item]
            cell.hasBorder = indexPath.item == lastSelectedFilterCellIndex?.item
            // initially selecting the 0 item
            if lastSelectedFilterCellIndex == nil {
                lastSelectedFilterCellIndex = indexPath
                cell.hasBorder = true
            }
            return cell
        } else {
            guard let cell: FrameCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FrameCell.self), for: indexPath) as? FrameCell else {
                fatalError("unexpected cell in collection view")
            }
            let image = draggedNode != nil ? draggedNode!.image! : self.image
            cell.setup(item: indexPath.item, image: image, frameImage: framesImages[indexPath.item])
            cell.hasBorder = lastSelectedFrameCellIndex == nil || indexPath.item == lastSelectedFrameCellIndex?.item
            // initially selecting the 0 item
            if lastSelectedFrameCellIndex == nil {
                lastSelectedFrameCellIndex = indexPath
                cell.hasBorder = true
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let unknownTypedCell = collectionView.cellForItem(at: indexPath)
        if collectionView == filtersCollectionView, let cell = unknownTypedCell as? FilterCell {
            if let index = lastSelectedFilterCellIndex, let lastCell = collectionView.cellForItem(at: index) as? FilterCell {
                lastCell.hasBorder = false
            }
            cell.hasBorder = true
            lastSelectedFilterCellIndex = indexPath
            self.draggedNode?.setup(image: thumbnailImages[indexPath.item])
            framesCollectionView.reloadData()
        } else if let cell = unknownTypedCell as? FrameCell {
            if let index = lastSelectedFrameCellIndex, let lastCell = collectionView.cellForItem(at: index) as? FrameCell {
                lastCell.hasBorder = false
            }
            cell.hasBorder = true
            lastSelectedFrameCellIndex = indexPath
            self.draggedNode?.set(frame: cell.frameType!)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
