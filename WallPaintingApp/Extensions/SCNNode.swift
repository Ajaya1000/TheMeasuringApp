//
//  SCNNode.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 20/02/23.
//

import Foundation
import SceneKit

extension SCNNode {
    func addText(text: String, font: UIFont, color: UIColor) {
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.font = font
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(x: 1, y: 1, z: 1) // Adjust scale as needed
        textNode.position = SCNVector3(x: 0, y: 0.2, z: 0) // Adjust position as needed
        textNode.geometry?.firstMaterial?.diffuse.contents = color
        
        self.addChildNode(textNode)
    }
}
