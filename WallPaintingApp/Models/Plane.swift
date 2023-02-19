//
//  Plane.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 18/02/23.
//

import Foundation
import ARKit

class Plane: SCNNode {
    
    // MARK: - Private Properties
    private var planeGeometry: SCNBox?
    
    // MARK: - Initializer
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        setupPlaneGeometry(anchor: anchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupPlaneGeometry(anchor: ARPlaneAnchor) {
        // dimensions
        let x = CGFloat(anchor.extent.x)
        let y = 0.5 as CGFloat
        let z = CGFloat(anchor.extent.z)
        
        // geometry
        planeGeometry = SCNBox(width: x, height: y, length: z, chamferRadius: 0)
        
        let gridMaterial = giveGridMaterial()
        let transparentMaterial = transParentMaterial()
        
        planeGeometry?.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, gridMaterial, transparentMaterial]
        setupPlaneNode(planeHeight: z)
        setTextureScale()
    }
    
    private func setupPlaneNode(planeHeight: CGFloat) {
        // create plane node
        let planeNode = SCNNode(geometry: self.planeGeometry)
        
        // put on surface
        planeNode.position = SCNVector3(0, -planeHeight * 0.5, 0)
        
        // add node to self object
        addChildNode(planeNode)
        
        // set texture scale
    }
    
    private func setTextureScale() {
        guard let width = planeGeometry?.width,
              let height = planeGeometry?.height else {
            return
        }
        
        // scaling grid texture
        let material = self.planeGeometry?.materials[4]
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material?.diffuse.wrapS = .repeat
        material?.diffuse.wrapT = .repeat
    }
    
    private func giveGridMaterial() -> SCNMaterial {
        // material: grid image
        let material = SCNMaterial()
        material.diffuse.contents = Images.grid
        
        return material
    }
    
    private func transParentMaterial() -> SCNMaterial{
        // transparent materials
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = Colors.transparent
        
        return transparentMaterial
    }
}