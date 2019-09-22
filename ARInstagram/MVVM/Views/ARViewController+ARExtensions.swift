//
//  ARViewController+ARExtensions.swift
//  ARAlbum
//
//  Created by nativ levy on 10/06/2019

import Foundation
import UIKit
import ARKit

extension ARViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !initVirtualTiles else { return }
        if let name = anchor.name, name == "tile_node_anchor" {
            prepareNodes(inside: node)
//            addTileNode(to: node)
            self.grids.forEach { $0.removeFromParentNode() }
            return
        }
        
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        // Bigger the 1 meter
        if planeAnchor.extent.x * planeAnchor.extent.z > 0.1 { // TODO set to 1
            addTileNodeAnchor(worldTransform: anchor.transform)
            return
        }
        let grid = Grid(anchor: planeAnchor)
        self.grids.append(grid)
        node.addChildNode(grid)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard !initVirtualTiles, let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == planeAnchor.identifier
            }.first
        
        // Bigger the 1 meter
        if planeAnchor.extent.x * planeAnchor.extent.z > 0.1 { // TODO set to 1
            addTileNodeAnchor(worldTransform: anchor.transform)
            return
        }
        
        guard let foundGrid = grid else {
            return
        }
        
        foundGrid.update(anchor: planeAnchor)
    }
    
    private func addTileNodeAnchor(worldTransform: simd_float4x4) {
        sceneView.session.add(anchor: ARAnchor(name: "tile_node_anchor", transform: worldTransform))
    }
    
//    private func addTileNode(to node: SCNNode) {
//        self.tileNode = TileNode()
//        if let index = self.lastSelectedFilterCellIndex {
//            self.tileNode?.setup(image: self.thumbnailImages[index.item])
//        } else {
//            self.tileNode?.setup(image: self.image)
//        }
//        if let index = self.lastSelectedFrameCellIndex, let cell = self.framesCollectionView.cellForItem(at: index) as? FrameCell {
//            self.tileNode?.set(frame: cell.frameType!)
//        }
//        node.addChildNode(self.tileNode!)
//    }
}
