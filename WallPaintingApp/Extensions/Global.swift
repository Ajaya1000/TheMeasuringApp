//
//  Global.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 19/02/23.
//

import Foundation
import ARKit

func *(matrix: SCNMatrix4, vector: SCNVector3) -> SCNVector3 {
    let x = matrix.m11 * vector.x + matrix.m21 * vector.y + matrix.m31 * vector.z + matrix.m41
    let y = matrix.m12 * vector.x + matrix.m22 * vector.y + matrix.m32 * vector.z + matrix.m42
    let z = matrix.m13 * vector.x + matrix.m23 * vector.y + matrix.m33 * vector.z + matrix.m43
    return SCNVector3(x, y, z)
}
