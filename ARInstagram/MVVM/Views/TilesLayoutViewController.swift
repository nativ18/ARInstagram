import UIKit
import Gallery
import Lightbox
import AVFoundation
import AVKit
import SVProgressHUD

class TilesLayoutViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var gallery: GalleryController?
    var selectedItem: CopyableCell?
    var topSafeAreaAndNavBarHeight: CGFloat?
    var topSelectedCellItem: CopyableCell?
    var barButton: UIBarButtonItem!
    @IBOutlet weak var blockingWhiteView: UIView!
    
    var selectedImages = [UIImage?]()
    
    var images: [UIImage] = [UIImage(named: "tile")!, UIImage(named: "3-In-Line")!, UIImage(named: "3-in-diagonal")!, UIImage(named: "3-in-column")!, UIImage(named: "pyramid")! ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DiagonalTilesCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DiagonalTilesCell")
        collectionView.register(UINib(nibName: "PyramidTilesCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PyramidTilesCell")
        collectionView.register(UINib(nibName: "ColumnsTilesCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ColumnsTilesCell")
        collectionView.register(UINib(nibName: "LineTilesCell", bundle: Bundle.main), forCellWithReuseIdentifier: "LineTilesCell")
        collectionView.register(UINib(nibName: "SingleTileCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SingleTileCell")
        
        barButton = UIBarButtonItem(title: "Go AR", style: .done, target: self, action: #selector(self.goARTapped(_ :)))
        navigationItem.setRightBarButton(barButton, animated: false)
        barButton.isEnabled = false

        var topViewsHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topViewsHeight = (window?.safeAreaInsets.top ?? 0)
        }
        topSafeAreaAndNavBarHeight = topViewsHeight + (navigationController?.navigationBar.frame.height ?? 0)
    }
    
    @objc func goARTapped(_ sender: UIBarButtonItem) {
        let images = selectedImages.compactMap{ $0 }
        guard images.count > 0 else { return }
        gallery?.dismiss(animated: false, completion: nil)
        var type: ARViewController.TileNodeType?
        switch selectedItem {
        case is SingleTileCell:
            type = .single
        case is LineTilesCell:
            type = .line
        case is ColumnsTilesCell:
            type = .column
        case is DiagonalTilesCell:
            type = .diagonal
        case is PyramidTilesCell:
            type = .pyramid
        default:
            break
        }
        showARViewController(images: images, tilesType: type!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        restart()
    }
    
    func restart() {
        topSelectedCellItem?.removeFromSuperview()
        collectionView.reloadData()
        gallery?.dismiss(animated: false, completion: nil)
        selectedImages.removeAll()
        blockingWhiteView.alpha = 0
    }
}

extension TilesLayoutViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            selectedItem = cell as? CopyableCell
            showGallery()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TileLayoutCell {
            cell.backgroundColor = UIColor.white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension TilesLayoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: CGFloat?
        switch indexPath.item {
        case 0:
            height = SingleTileCell.cellHeight
        case 1:
            height = LineTilesCell.cellHeight
        case 2:
            height = ColumnsTilesCell.cellHeight
        case 3:
            height = DiagonalTilesCell.cellHeight
        case 4:
            height = PyramidTilesCell.cellHeight
        default:
            break
        }

        let size = CGSize(width: view.frame.width, height: height!)
        return size
    }
}

extension TilesLayoutViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        var cell: UICollectionViewCell?
        switch indexPath.item {
        case 0:
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SingleTileCell.self), for: indexPath) as? SingleTileCell)!
            (cell as? SingleTileCell)?.initSetup()
        case 1:
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LineTilesCell.self), for: indexPath) as? LineTilesCell)!
            (cell as? LineTilesCell)?.initSetup()
        case 2:
           cell = (collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ColumnsTilesCell.self), for: indexPath) as? ColumnsTilesCell)!
           (cell as? ColumnsTilesCell)?.initSetup()

        case 3:
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DiagonalTilesCell.self), for: indexPath) as? DiagonalTilesCell)!
            (cell as? DiagonalTilesCell)?.initSetup()
        case 4:
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PyramidTilesCell.self), for: indexPath) as? PyramidTilesCell)!
            (cell as? PyramidTilesCell)?.initSetup()
        default:
            break
        }
        return cell!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
    }
    
}

extension TilesLayoutViewController {
    
    func showGallery() {
        
        Gallery.Config.tabsToShow = [.imageTab, .cameraTab]
        Gallery.Config.initialTab = .imageTab
        gallery = GalleryController()
        gallery?.title = "Select 1 Image"
        gallery?.modalPresentationStyle = .custom
        gallery?.transitioningDelegate = self
        gallery?.delegate = self
        
        self.present(gallery!, animated: true, completion: nil)

        if let newCell = self.selectedItem?.copyCell() {
            newCell.frame = CGRect(x: newCell.frame.minX, y: newCell.frame.minY + self.topSafeAreaAndNavBarHeight!, width: newCell.frame.width, height: newCell.frame.height)
            view.addSubview(newCell)
            UIView.animate(withDuration: 0.15,
                           delay: 0.0,
                           options: [],
                           animations: {
                            self.blockingWhiteView.alpha = 1
            },
                           completion: nil)
            UIView.animate(withDuration: 0.3,
                           delay: 0.05,
                           options: [],
                           animations: {
                            newCell.frame = CGRect(x: 0, y: self.topSafeAreaAndNavBarHeight!, width: self.selectedItem!.frame.width, height: self.selectedItem!.frame.height)
            },
                           completion: nil)
            topSelectedCellItem = newCell
        }
    }
    
    @objc
    func didTap() {
        print("tap2")
    }
}

extension TilesLayoutViewController: UIViewControllerTransitioningDelegate {
 
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard presented is GalleryController else { return UIPresentationController(presentedViewController: presented, presenting: presenting) }
        
        let p = HalfSizePresentationController(presentedViewController:presented, presenting: presenting)
        p.selectedItemHeight = selectedItem!.frame.height
        p.navBarHeight = topSafeAreaAndNavBarHeight!
        return p
    }
}

class HalfSizePresentationController: UIPresentationController {
    
    var selectedItemHeight: CGFloat = 0
    var navBarHeight: CGFloat = 0
    var seperatorHeight: CGFloat = 2
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: selectedItemHeight + navBarHeight - seperatorHeight, width: containerView!.bounds.width, height: containerView!.bounds.height - selectedItemHeight - navBarHeight + seperatorHeight)
    }
}
