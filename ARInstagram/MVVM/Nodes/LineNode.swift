//
//  LineNode.swift
//  KDTree
//
//  Created by nativ levy on 23/04/2019.
//

import Foundation
import ARKit

class LineNode: SCNNode {
    
    var from: SCNVector3!
    var to: SCNVector3!
    
    init(from: SCNVector3, to: SCNVector3, radius: CGFloat = 0.0, name: String?, locked: Bool = false) {
        self.from = from
        self.to = to
        super.init()
        build(radius: radius)
    }
    
    func build(radius: CGFloat = 0.02) {
        
        let vector = to - from
        let height = vector.length()
        let cylinder = SCNCylinder(radius: radius, height: CGFloat(height))
        cylinder.radialSegmentCount = 4
        geometry = cylinder
        let v = to + from
        position = SCNVector3(x: v.x / 2, y: v.y / 2, z: v.z / 2)
        eulerAngles = SCNVector3.lineEulerAngles(vector: vector)
        self.name = name
        geometry?.firstMaterial?.diffuse.contents = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
