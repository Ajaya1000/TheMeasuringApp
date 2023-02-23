//
//  SCNMatrix4.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 20/02/23.
//

import Foundation
import SceneKit

extension SCNMatrix4 {
    var eulerAngles: SCNVector3 {
        let sy = sqrt(m11 * m11 + m12 * m12)
        let singular = sy < 1e-6
        
        var x: Float, y: Float, z: Float
        
        if !singular {
            x = atan2(m23, m33)
            y = atan2(-m13, sy)
            z = atan2(m12, m11)
        } else {
            x = atan2(-m32, m22)
            y = atan2(-m13, sy)
            z = 0.0
        }
        
        return SCNVector3(x, y, z)
    }
}
