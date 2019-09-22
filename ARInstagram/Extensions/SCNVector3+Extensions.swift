//
//  SCNVector3+Extensions.swift
//  Trax
//
//  Created by Bar Fingerman on 28/08/2017.
//  Copyright © 2017 Bar Fingerman. All rights reserved.
//

import UIKit
import ARKit

extension SCNVector3: Hashable, Equatable {
    
    public func toArray() -> [Float] {
        return [self.x, self.y, self.z]
    }
    
    public init(from array: [Float]) throws {
        guard array.count == 3 else {
            self.init(0, 0, 0)
            return
        }
        self.init(array[0], array[1], array[2])
    }

    init(_ vec: vector_float3) {
        self.init()
        self.x = vec.x
        self.y = vec.y
        self.z = vec.z
    }
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    public static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func friendlyString() -> String {
        return "(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)), \(String(format: "%.2f", z)))"
    }
   
    static func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
    }
    
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    func dot(_ vec: SCNVector3) -> Float {
        return (self.x * vec.x) + (self.y * vec.y) + (self.z * vec.z)
    }
    
    func cross(_ vec: SCNVector3) -> SCNVector3 {
        return SCNVector3(self.y * vec.z - self.z * vec.y, self.z * vec.x - self.x * vec.z, self.x * vec.y - self.y * vec.x)
    }
    
    public static func matrixMul(vector: SCNVector3, transform: matrix_float4x4) -> SCNVector3 {
    
      let as4DVector = simd_float4(vector.x, vector.y, vector.z, 1)
      let realWorldVec = simd_mul(transform, as4DVector)
      return SCNVector3(realWorldVec.x, realWorldVec.y, realWorldVec.z)
    }
    
    public func distance(_ vector: SCNVector3) -> Float {
        return sqrt(pow(x - vector.x, 2) + pow(y - vector.y, 2) + pow(z - vector.z, 2))
    }
    
    public func distanceIgnoreY(_ vector: SCNVector3) -> Float {
        return sqrt(pow(x - vector.x, 2) + pow(z - vector.z, 2))
    }
    
    public var hashValue: Int {
        return x.hashValue << 32 ^ y.hashValue << 16 ^ z.hashValue
    }
    
    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return abs(lhs.x - rhs.x) < 0.000001 &&
               abs(lhs.y - rhs.y) < 0.000001 &&
               abs(lhs.z - rhs.z) < 0.000001
    }
    
    public mutating func round(accuracy: Float = 1) {
        x = Darwin.round(x / accuracy) * accuracy
        y = Darwin.round(y / accuracy) * accuracy
        z = Darwin.round(z / accuracy) * accuracy
    }
    
    public func rounded(accuracy: Float = 1) -> SCNVector3 {
        var res = self
        res.round(accuracy: accuracy)
        return res
    }
}

extension SCNVector3 {
    static func lineEulerAngles(vector: SCNVector3) -> SCNVector3 {
        let height = vector.length()
        let lxz = sqrtf(vector.x * vector.x + vector.z * vector.z)
        let pitchB = vector.y < 0 ? Float.pi - asinf(lxz/height) : asinf(lxz/height)
        let pitch = vector.z == 0 ? pitchB : sign(vector.z) * pitchB
        
        var yaw: Float = 0
        if vector.x != 0 || vector.z != 0 {
            let inner = vector.x / (height * sinf(pitch))
            if inner > 1 || inner < -1 {
                yaw = Float.pi / 2
            } else {
                yaw = asinf(inner)
            }
        }
        return SCNVector3(CGFloat(pitch), CGFloat(yaw), 0)
    }
}
