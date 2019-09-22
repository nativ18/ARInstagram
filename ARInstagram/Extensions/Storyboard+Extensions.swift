//
//  Storyboard+Extensions.swift
//  BarcodeCollector
//
//  Created by nativ levy on 30/05/2019.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    func instantiate<T: UIViewController>() -> T {
        let name = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return instantiateViewController(withIdentifier: name) as! T
    }
    class var main: UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
}
