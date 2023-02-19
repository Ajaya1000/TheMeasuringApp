//
//  UIColor.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 19/02/23.
//

import UIKit

extension UIColor {
    static func fromHex(r: Int, g: Int, b: Int, a: Float) -> UIColor {
        return .init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
    }
}
