//
//  FrameNode.swift
//  ARAlbum
//
//  Created by nativ levy on 07/06/2019.
//
import Foundation
import UIKit
import ARKit

// https://stackoverflow.com/questions/46073981/how-to-create-a-border-for-scnnode-to-indicate-its-selection-in-ios-11-arkit-sce
class TileNode: SCNNode {
    
    static let hardcodedFrameWidth: CGFloat = 0.045

    var image: UIImage?
    let width: CGFloat = 0.3
    let height: CGFloat = 0.3
    
    var currentFrame: Frames? {
        didSet {
            (imageNode?.geometry as? SCNPlane)?.width = width - currentFrame!.internalFrameSize()
            (imageNode?.geometry as? SCNPlane)?.height = height - currentFrame!.internalFrameSize()
        }
    }
    
    enum Frames {
        case ever
        case classic
        case bold
        case clean
        
        static func build(from number: Int) -> Frames {
            switch number {
            case 0:
                return .clean
            case 1:
                return .classic
            case 2:
                return .ever
            case 3:
                return .bold
            default:
                return .bold
            }
        }
        
        func internalFrameSize() -> CGFloat {
            switch self {
            case .ever, .classic:
                return TileNode.hardcodedFrameWidth + 0.1
             case .bold, .clean:
                return TileNode.hardcodedFrameWidth
            }
        }
        
        func imageName() -> String {
            switch self {
            case .ever, .clean:
                return "ever"
            case .bold, .classic:
                return "classic"
            }
        }
        
        func image() -> UIImage {
            switch self {
            case .ever, .clean:
                return UIImage(named: "ever")!
            case .bold, .classic:
                return UIImage(named: "classic")!
            }
        }
    }
    
    var imageNode: SCNNode?
    var frameNode: SCNNode?
    
    override init() {
        super.init()
        name = "tile_node"
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        name = "tile_node"
        setup()
    }
    
    func setup() {
        geometry = SCNPlane(width: width, height: height)
    }
    
    func setup(image: UIImage) {
        
        self.image = image
        let squareImage = image.cropImageToSquare()
        eulerAngles.x = -.pi/2
        geometry?.firstMaterial?.isDoubleSided = true
        
        imageNode?.removeFromParentNode()
        imageNode = SCNNode(geometry: SCNPlane(width: width - (currentFrame?.internalFrameSize() ?? 0), height: height - (currentFrame?.internalFrameSize() ?? 0 )))
        imageNode?.geometry?.firstMaterial?.diffuse.contents = squareImage
        imageNode?.geometry?.firstMaterial?.readsFromDepthBuffer = false
        imageNode?.position.z += 0.001
        imageNode?.renderingOrder = 2
        imageNode?.name = "photo"
        
        addChildNode(imageNode!)
        if currentFrame == nil {
            currentFrame = .clean
        }
    }
    
    func set(frame: Frames) {
        
        currentFrame = frame
        frameNode?.removeFromParentNode()
        frameNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        frameNode?.geometry?.firstMaterial?.diffuse.contents = frame.image()
        frameNode?.name = "frame"
        addChildNode(frameNode!)
    }
}
