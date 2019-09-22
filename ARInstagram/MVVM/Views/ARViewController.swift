//
//  ViewController.swift
//  ARAlbum
//
//  Created by nativ levy on 07/06/2019.
//

import UIKit
import ARKit
import AVFoundation
import AVKit
import PromiseKit

class ARViewController: UIViewController {
    
    enum TileNodeType {
        case single
        case line
        case column
        case diagonal
        case pyramid
    }
    
    let filters: [(name: String, applier: FilterApplierType?)] = [
        (name: "Normal",
         applier: nil),
        (name: "Nashville",
         applier: ImageHelper.applyNashvilleFilter),
        (name: "Toaster",
         applier: ImageHelper.applyToasterFilter),
        (name: "1977",
         applier: ImageHelper.apply1977Filter),
        (name: "Clarendon",
         applier: ImageHelper.applyClarendonFilter),
        (name: "HazeRemoval",
         applier: ImageHelper.applyHazeRemovalFilter),
        (name: "Chrome",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectChrome")),
        (name: "Fade",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectFade")),
        (name: "Instant",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectInstant")),
        (name: "Mono",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectMono")),
        (name: "Noir",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectNoir")),
        (name: "Process",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectProcess")),
        (name: "Tonal",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTonal")),
        (name: "Transfer",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTransfer")),
        (name: "Tone",
         applier: ImageHelper.createDefaultFilterApplier(name: "CILinearToSRGBToneCurve")),
        (name: "Linear",
         applier: ImageHelper.createDefaultFilterApplier(name: "CISRGBToneCurveToLinear")),
    ]
    
    var touchBeganTime: Date?
    var ciContext = CIContext(options: nil)
    var thumbnailImages: [UIImage] = []
    var framesImages: [UIImage] = []
    var layouts: [UIImage] = []
    var tileHasMoved = false
    
    var tilesNodeType: TileNodeType!
    var images: [UIImage]!
    var image: UIImage {
        set {
            applyFilters(image: newValue)
            framesCollectionView.reloadData()
            filtersCollectionView.reloadData()
        }
        get {
            return images[0]
        }
    }
    var initVirtualTiles = false
    
    var grids = [Grid]()
    var draggedNode: TileNode?
    
    var lastSelectedFrameCellIndex: IndexPath?
    var lastSelectedFilterCellIndex: IndexPath?
    
    @IBOutlet weak var bottomViews: UIView!
    @IBOutlet weak var framesCollectionView: UICollectionView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var framesBtn: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var bottomViewsTopBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scanWallLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        framesCollectionView.delegate = self
        framesCollectionView.dataSource = self
        
        func setTitleColor(for button: UIButton) {
            button.setTitleColor(UIColor.black, for: .selected)
            button.setTitleColor(UIColor.lightGray, for: .disabled)
        }
        
        setTitleColor(for: framesBtn)
        setTitleColor(for: filterBtn)
        
        framesImages.append(contentsOf: ([UIImage(named: "ever")!, UIImage(named: "classic")!, UIImage(named: "ever")!, UIImage(named: "classic")!]))
        fadeBottomLabel()
    }
    
    func fadeBottomLabel() {
        guard let _ = scanWallLabel else { return }
        scanWallLabel.fadeOut(0.5, delay: 0) { [weak self] b in
            guard let _ = self?.scanWallLabel else { return }
            self?.scanWallLabel.fadeIn(0.5, delay: 0, completion: { [weak self] b in
                self?.fadeBottomLabel()
            })
        }
    }
    
    func addNodes(to node: SCNNode) -> Promise<Bool> {
        return Promise { seal in
            var animDelay = 0.0
            
            func addNodeAt(position: SCNVector3, image: UIImage) {
                let node1 = TileNode()
                node1.setup(image: image)
                node1.set(frame: .clean)
                node1.position = position
                node1.opacity = 0
                node.addChildNode(node1)
                let fadeInAnim = SCNAction.group([SCNAction.wait(duration: animDelay), SCNAction.fadeIn(duration: 1.0)])
                node1.runAction(fadeInAnim)
                animDelay += 2.0
            }
            
            switch self.tilesNodeType! {
            case .line:
                let position = node.position
                var leftTilePosition = position
                leftTilePosition.x -= 0.4
                addNodeAt(position: leftTilePosition, image: images[0])
                addNodeAt(position: position, image: images[1])
                var rightTilePosition = position
                rightTilePosition.x += 0.4
                addNodeAt(position: rightTilePosition, image: images[2])
                node.name = "tiles_container"
            case .single:
                addNodeAt(position: node.position, image: images[0])
            case .column:
                let position = node.position
                var leftTilePosition = position
                leftTilePosition.z -= 0.4
                addNodeAt(position: leftTilePosition, image: images[0])
                addNodeAt(position: position, image: images[1])
                var rightTilePosition = position
                rightTilePosition.z += 0.4
                addNodeAt(position: rightTilePosition, image: images[2])
                node.name = "tiles_container"
            default:
                break
            }
            initVirtualTiles = true
            seal.fulfill(true)
        }
    }
    
    func animateBottomViews() -> Promise<Bool> {
        return Promise { seal in
            self.scanWallLabel.fadeOut(0.5, delay: 0) { succeed in
                self.scanWallLabel.removeFromSuperview()
                
                DispatchQueue.main.async {
                    let bottomViewHeight: CGFloat = 170
                    let bottomSafeArea = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
                    let totalHeight = bottomViewHeight + bottomSafeArea
                    self.bottomViews.frame = CGRect(x: 0, y: self.view.frame.maxY + bottomSafeArea, width: self.view.frame.width, height: totalHeight)
                    
                    UIView.animate(withDuration: 0.6,
                                   delay: 0.0,
                                   options: [],
                                   animations: {
                                    let frame = CGRect(x: 0, y: self.view.frame.maxY - totalHeight, width: self.view.frame.width, height: totalHeight)
                                    self.bottomViews.frame = frame
                    }, completion: { succeed in
                        self.bottomViewsTopBottomConstraint.constant = -totalHeight
                    })
                }
            }
        }
    }
    
    func prepareNodes(inside node: SCNNode) {
        
        addNodes(to: node).then { [weak self] _ -> Promise<Bool> in
            guard let self = self else { return brokenPromise() }
            return self.animateBottomViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach {
            let touch = $0
            if(touch.view == self.sceneView) {
                let viewTouchLocation = touch.location(in: sceneView)
                let arHitTestResult = sceneView.hitTest(viewTouchLocation, types: .featurePoint)
                guard arHitTestResult.count > 0 else {
                    return
                }
                
                let result = sceneView.hitTest(viewTouchLocation, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.all.rawValue])
                guard !result.isEmpty else {
                    return
                }
                
                tileHasMoved = false
                
                for hitTestResult in result {
                    let topNode = hitTestResult.node
                    var currentTileNode: TileNode?
                    if topNode is TileNode {
                        currentTileNode = topNode as? TileNode
                    } else if topNode.parent?.name == "tile_node" {
                        currentTileNode = topNode.parent as? TileNode
                    }
                    if let tileNode = currentTileNode {
                        // highlight its material
                        setTileNode(selectedColor: UIColor.black)
                        draggedNode = tileNode
                        setTileNode(selectedColor: UIColor.blue)
                        image = tileNode.image!
                        touchBeganTime = Date()
                        tileHasMoved = false
                        return
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchBeganTime = touchBeganTime, Date().timeIntervalSince1970 -  touchBeganTime.timeIntervalSince1970 > 0.3 else {
            return
        }
        guard let draggedNode = draggedNode else { return }
        touches.forEach {
            let touch = $0
            if touch.view == self.sceneView {
                let viewTouchLocation = touch.location(in: sceneView)
                let results = sceneView.hitTest(viewTouchLocation, types: .existingPlane)
                guard results.count > 0 else { return }
                draggedNode.simdWorldTransform = results[0].worldTransform
                draggedNode.eulerAngles.x = -.pi/2
                tileHasMoved = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard tileHasMoved else { return }
        setTileNode(selectedColor: UIColor.black)
        self.draggedNode = nil
    }
    
    func setTileNode(selectedColor: UIColor = UIColor.blue) {
        guard let draggedNode = draggedNode else { return }
        SCNTransaction.begin()
        draggedNode.frameNode?.geometry?.firstMaterial?.emission.contents = selectedColor
        SCNTransaction.commit()
    }
    
    func setupScene() {
        
        let sessionConfig: ARWorldTrackingConfiguration = ARWorldTrackingConfiguration()
        sessionConfig.planeDetection = .vertical
        sceneView.session.delegate = self
        sceneView.debugOptions = .showFeaturePoints
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = true
        sceneView.preferredFramesPerSecond = 60
        enableEnvironmentMapWithIntensity(25.0)
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
        sceneView.session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
        sceneView.delegate = self
    }
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    @IBAction func filtersTapped(_ sender: Any) {
        filterBtn.isSelected = true
        framesBtn.isSelected = false
        filtersCollectionView.isHidden = false
        framesCollectionView.isHidden = true
        filtersCollectionView.reloadData()
    }
    
    @IBAction func framesTapped(_ sender: Any) {
        filterBtn.isSelected = false
        framesBtn.isSelected = true
        filtersCollectionView.isHidden = true
        framesCollectionView.isHidden = false
        framesCollectionView.reloadData()
    }
}



func brokenPromise<T>(method: String = #function) -> Promise<T> {
    return Promise<T>() { seal in
        let err = NSError(
            domain: "AddingBottomNodes",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "'\(method)' not yet implemented."])
        seal.reject(err)
    }
}
