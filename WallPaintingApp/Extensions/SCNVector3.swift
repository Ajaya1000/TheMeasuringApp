//
//  SCNVector3.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 19/02/23.
//

import Foundation
import ARKit
extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    static func /(vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(x: vector.x / scalar, y: vector.y / scalar, z: vector.z / scalar)
    }

        
    func distance(to vector: SCNVector3) -> Float {
        let dx = self.x - vector.x
        let dy = self.y - vector.y
        let dz = self.z - vector.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }
    
    func normalized() -> SCNVector3 {
        let length = sqrt(x * x + y * y + z * z)
        if length == 0 {
            return SCNVector3(0, 0, 0)
        } else {
            return SCNVector3(x / length, y / length, z / length)
        }
    }
}

