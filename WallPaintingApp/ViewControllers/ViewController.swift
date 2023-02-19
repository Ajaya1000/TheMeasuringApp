//
//  ViewController.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 18/02/23.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sceneView: ARSCNView!
    
    // MARK: - Private Properties
    var dictPlanes = [ARPlaneAnchor: Plane]()
    private var startNode: SCNNode?
    private var lineNode: SCNNode?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up scene
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set up session
        setupARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    // MARK: - IBActions
    @IBAction func onAddButtonAction(_ sender: Any) {
        guard let position = doHitTestOnExistingPlanes() else {
            return
        }
        
        let node = nodeWithPosition(position)
        sceneView.scene.rootNode.addChildNode(node)
        
        startNode = node
    }
    
    // MARK: - Private Methods
    private func setupScene() {
        
        // set delegate ARSCNViewDelegate
        sceneView.delegate = self
        
        // showing statitics (fps, timing info)
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        // debug points
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // create new scene
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    private func setupARSession() {
        // create session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // set to detect horizontal planes
        configuration.planeDetection = .horizontal
        
        // run the configuration
        sceneView.session.run(configuration)
    }
    
    private func doHitTestOnExistingPlanes() -> SCNVector3? {
        let results = sceneView.hitTest(view.center, types: .existingPlaneUsingExtent)
        
        guard let result = results.first else {
            return nil
        }
        
        let hitPos = positionFromTransform(result.worldTransform)
        return hitPos
    }
    
    private func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    private func nodeWithPosition(_ position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.003)
        
        sphere.firstMaterial?.diffuse.contents = Colors.red
        sphere.firstMaterial?.lightingModel = .constant
        sphere.firstMaterial?.isDoubleSided = true
        
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        return node
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // create plane with the "PlaneAnchor"
                let plane = Plane(anchor: planeAnchor)
                // add to the detected
                node.addChildNode(plane)
                
                self.dictPlanes[planeAnchor] = plane
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let plane = self.dictPlanes[planeAnchor]
                
                plane?.updateWith(planeAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            dictPlanes.removeValue(forKey: planeAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            guard let currentPosition = self.doHitTestOnExistingPlanes(),
                  let start = self.startNode else {
                return
            }
            
            self.lineNode?.removeFromParentNode()
            self.lineNode = self.getDrawnLineFrom(from: currentPosition, to: start.position)
            
            guard let lineNode = self.lineNode else { return }
            self.sceneView.scene.rootNode.addChildNode(lineNode)
        }
    }
}

// MARK: - Making Line Node
extension ViewController {
    private func getDrawnLineFrom(from pos1: SCNVector3, to pos2: SCNVector3) -> SCNNode {
        let line = lineFrom(from: pos1, to: pos2)
        
        // set the material color
        let material = SCNMaterial()
        material.diffuse.contents = Colors.red
        line.firstMaterial = material
        
        let lineNode = SCNNode(geometry: line)
        
        return lineNode
    }
    
    private func lineFrom(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return .init(sources: [source], elements: [element])
    }
}
