//
//  UIView+Extensions.swift
//  ARAlbum
//
//  Created by nativ levy on 19/06/2019

import Foundation
import UIKit

@available(iOS 11.3, *)
extension UIView {
    
    enum Orientation {
        
        case landscape
        case portrait
    }
    
    func showBorder() {
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.blue.cgColor
    }
    
    func removeBorder() {
        
        layer.borderWidth = 0
    }
    
    @discardableResult
    func fill(in view: UIView) -> (left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        
        if !view.subviews.contains(self) {
            view.addSubview(self)
        }
        translatesAutoresizingMaskIntoConstraints = false
        let left = leadingAnchor.constraint(equalTo: view.leadingAnchor)
        left.isActive = true
        let right = trailingAnchor.constraint(equalTo: view.trailingAnchor)
        right.isActive = true
        let top = topAnchor.constraint(equalTo: view.topAnchor)
        top.isActive = true
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottom.isActive = true
        return (left, right, top, bottom)
    }
    
    func center(in view: UIView) {
        
        if !view.subviews.contains(self) {
            view.addSubview(self)
        }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    var orientation: Orientation {
        
        if bounds.size.width < bounds.size.height {
            
            return .portrait
        }
        return .landscape
    }
    
    @discardableResult
    func setBottomBorder(lineHeight: CGFloat, color: UIColor) -> CALayer {
        
        let lineRect = CGRect(x: 0.0, y: frame.height - lineHeight, width: frame.width, height: lineHeight)
        return addLineIn(rect: lineRect, and: color)
    }
    
    func setBottomBorder(lineHeight: CGFloat, color: UIColor, layer: CALayer) {
        
        let lineRect = CGRect(x: 0.0, y: frame.height - lineHeight, width: frame.width, height: lineHeight)
        addLineIn(in: lineRect, with: color, using: layer)
    }
    
    fileprivate func addLineIn(in rect: CGRect, with color: UIColor, using aLayer: CALayer) {
        
        aLayer.frame = rect
        aLayer.backgroundColor = color.cgColor
        layer.addSublayer(aLayer)
    }
    
    @discardableResult
    func setTopBorder(lineHeigth: CGFloat, color: UIColor) -> CALayer {
        
        let lineRect = CGRect(x: 0.0, y: 0.0, width: frame.width, height: lineHeigth)
        return addLineIn(rect: lineRect, and: color)
    }
    
    fileprivate func addLineIn(rect: CGRect, and color: UIColor) -> CALayer {
        
        let line = CALayer()
        line.frame = rect
        line.backgroundColor = color.cgColor
        layer.addSublayer(line)
        return line
    }
    
    func indexPath(forTable table: UITableView) -> IndexPath? {
        
        let center: CGPoint = self.center
        guard let rootViewPoint: CGPoint = self.superview?.convert(center, to:table),
            let indexPath: IndexPath = table.indexPathForRow(at: rootViewPoint) else {
                return nil
        }
        return indexPath
    }
    
    func addSahdow(with color: UIColor = .black) {
        
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = true
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.2
        layer.shadowPath = shadowPath.cgPath
        clipsToBounds = false
    }
    
    func showActivityIndicator(color aColor: UIColor) {
        
        hideActivityIndicator()
        
        let activityIndicator = UIActivityIndicatorView(frame: self.frame)
        activityIndicator.color = aColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tag = self.hash
        activityIndicator.backgroundColor = UIColor.red
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        
        for view in self.subviews where view.tag == self.hash {
            view.removeFromSuperview()
        }
    }
    
    func shake(repeatCount count: Float = Float.infinity) {
        
        let transform = CAKeyframeAnimation(keyPath:"transform")
        transform.values = [NSValue(caTransform3D: CATransform3DMakeRotation(0.1, 0.0, 0.0, 1.0)),
                            NSValue(caTransform3D: CATransform3DMakeRotation(-0.1, 0, 0, 1))]
        transform.autoreverses = true
        transform.duration = 0.105
        transform.repeatCount = count
        self.layer.add(transform, forKey: "transform")
    }
    
    func degreesToRadians(_ x: CGFloat) -> CGFloat {
        return CGFloat(Double.pi) * x / 180.0
    }
    
    func pulse(duration dur: Double) {
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = dur
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 1.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(pulseAnimation, forKey: "pulse_animation")
    }
    
    /// detail before execute
    public func delay(seconds: Double, completion:@escaping () -> ()) {
        
        let when = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion()
        }
    }
    
    func pulseAnimation(_ duration: Double, completion comp:(() -> Void)?) {
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 1.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        self.layer.add(pulseAnimation, forKey: "pulse_animation")
        
        delay(seconds: duration*2) { () -> () in
            comp?()
        }
    }
    
    func rotate360Degrees(duration dur: Double, repeatCount: Float, completion comp: (() -> Void)? = nil) {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = dur
        
        if repeatCount == Float.greatestFiniteMagnitude {
            rotateAnimation.repeatCount = Float.greatestFiniteMagnitude
        } else {
            rotateAnimation.repeatCount = repeatCount
            delay(seconds: Double(dur)*Double(rotateAnimation.repeatCount)) { () -> () in
                comp?()
            }
        }
        self.layer.add(rotateAnimation, forKey: "transform.rotation")
    }
    
    func fadeIn(_ duration: TimeInterval = 0.8, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.8, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    public func screenshot(opaque: Bool = false, scale: CGFloat = 1) -> UIImage? {
        
        // Create the UIImage
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, opaque, scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    func loadFromNibNamed(_ nibNamed: String, bundle: Bundle? = nil) -> UIView? {
        
        return UINib(nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func round() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    func square() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
    }
    
    public func roundCorners(radius rad: CGFloat, borderColor: UIColor? = nil, corners: UIRectCorner = .allCorners, maskedCorners: CACornerMask? = nil) {
        
        if let mask = maskedCorners {
            layer.maskedCorners = mask
        }
        layer.cornerRadius = rad
        layer.masksToBounds = true
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = 1
        }
    }
    
    func indexPath(forTableView table: UITableView) -> IndexPath? {
        
        let center: CGPoint = self.center
        guard let rootViewPoint: CGPoint = self.superview?.convert(center, to:table),
            let indexPath: IndexPath = table.indexPathForRow(at: rootViewPoint) else {
                return nil
        }
        return indexPath
    }
    
    func indexPath(forCollectionView cv: UICollectionView) -> IndexPath? {
        
        let center: CGPoint = self.center
        guard let rootViewPoint: CGPoint = self.superview?.convert(center, to:cv),
            let indexPath: IndexPath = cv.indexPathForItem(at: rootViewPoint) else {
                return nil
        }
        return indexPath
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func addActivityIndicator() {
        
        let AI = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        AI.center = self.center
        AI.hidesWhenStopped = true
        AI.startAnimating()
        
        self.addSubview(AI)
    }
}

extension UIView {
    
    //    func addBackground<T: Backround> (_ background: T, positionX: CGFloat  = 0.5, positionY: CGFloat  = 0.5, clipToMargins: Bool = true) -> T.View where T.View: UIView {
    //
    //        let backgroundView = background.view
    //        addSubview(backgroundView)
    //        addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: positionX * 2, constant: 0))
    //
    //        addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerYWithinMargins, multiplier: positionY * 2, constant: 0))
    //        if clipToMargins {
    //            let constraints = [NSLayoutConstraint(item: backgroundView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0),
    //                               NSLayoutConstraint(item: backgroundView, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0),
    //                               NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .topMargin, multiplier: 1, constant: 0),
    //                               NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0)]
    //            addConstraints(constraints)
    //        }
    //        return backgroundView
    //    }
}
