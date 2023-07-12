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
    
    func length() -> Float {
        return sqrt(x * x + y * y + z * z)
    }
    
    func getEulerAngle() -> SCNVector3 {
        let rotationMatrix = SCNMatrix4MakeRotation(self.x, 1.0, 0.0, 1.0)
        return rotationMatrix.eulerAngles
    }
    
    func dot(_ vector: SCNVector3) -> Float {
        
        return (self.x * vector.x) + (self.y * vector.y) + (self.z * vector.z)
    }
    
    func angle(with vector: SCNVector3) -> Float {
        let vector1 = self.normalized()
        let vector2 = vector.normalized()
        
        let dotProduct = vector1.dot(vector2)
        let theta = acos(dotProduct)
        
        return deg2rad(theta)
    }
}

