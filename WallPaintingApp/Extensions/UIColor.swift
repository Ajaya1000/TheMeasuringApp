//
//  UIColor.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 19/02/23.
//

import UIKit
import ARKit

extension UIColor {
    var rgbComponents: simd_float3 {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            getRed(&r, green: &g, blue: &b, alpha: &a)
            return simd_float3(Float(r), Float(g), Float(b))
    }
    
    static func fromHex(r: Int, g: Int, b: Int, a: Float) -> UIColor {
        return .init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
    }
}
