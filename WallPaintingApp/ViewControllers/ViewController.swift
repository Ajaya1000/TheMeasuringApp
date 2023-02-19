//
//  ViewController.swift
//  WallPaintingApp
//
//  Created by Ajaya Mati on 18/02/23.
//

import UIKit
import ARKit

enum DistanceUnit {
    case meters
    case kilometers
    case feet
    case miles
    case cm
}

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        
        if startNode != nil {
            startNode = nil
            lineNode = nil
            
            let node = nodeWithPosition(position)
            sceneView.scene.rootNode.addChildNode(node)
            
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
//        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        // debug points
//        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
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
            
            let desc = self.getDistanceStringBetween(pos1: currentPosition, pos2: start.position)
            self.descriptionLabel.text = desc
        }
    }
}

// MARK: - Making Line Node
extension ViewController {
//    private func getDrawnLineFrom(from pos1: SCNVector3, to pos2: SCNVector3) -> SCNNode {
//        let line = lineFrom(from: pos1, to: pos2)
//
//        // set the material color
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        line.materials = [material]
//        line.firstMaterial?.diffuse.contents = UIColor.red
//        line.firstMaterial?.isDoubleSided = true
//
//        let lineNode = SCNNode(geometry: line)
//
//        return lineNode
//    }
//
//    private func lineFrom(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
//        let indices: [Int32] = [0, 1]
//        let source = SCNGeometrySource(vertices: [vector1, vector2])
//        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
//        return .init(sources: [source], elements: [element])
//    }
    
    func getDrawnLineFrom(from pos1: SCNVector3, to pos2: SCNVector3, color: UIColor = Colors.red, thickness: CGFloat = 0.1) -> SCNNode {
        // Create a geometry to represent the line
        let indices: [UInt32] = [0, 1]
        let source = SCNGeometrySource(vertices: [pos1, pos2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geometry = SCNGeometry(sources: [source], elements: [element])

        // Create a custom shader modifier to set the line's color and thickness
        let shaderModifier = """
            _geometry {
                vec3 start = _geometry.position.xyz;
                vec3 end = _geometry.position1.xyz;
                vec3 dir = end - start;
                float len = length(dir);
                dir = normalize(dir);
                vec3 point = start + dir * (_surface.diffuse.a - 0.5) * len * \(thickness);

                float t = length(point - start) / len;

                if (t < 0.05 || t > 0.95) {
                    discard;
                }

                _surface.diffuse.rgb = \(color.rgbComponents);
                _output.color = _surface.diffuse;
            }
        """

        // Set the custom shader modifier on the geometry
        geometry.shaderModifiers = [.surface: shaderModifier]

        // Create a node to hold the geometry
        let node = SCNNode(geometry: geometry)

        return node
    }

}

extension ViewController {
    private func getDistanceStringBetween(pos1: SCNVector3?, pos2: SCNVector3?, unit: DistanceUnit = .cm) -> String {
        guard let p1 = pos1, let p2 = pos2 else {
            return "Invalid positions"
        }
        
        let distance = p1.distance(to: p2)
        
        var distanceString: String
        switch unit {
        case .meters:
            distanceString = String(format: "%.2f", distance) + " m"
        case .kilometers:
            distanceString = String(format: "%.2f", distance/1000) + " km"
        case .feet:
            distanceString = String(format: "%.2f", distance*3.28084) + " ft"
        case .miles:
            distanceString = String(format: "%.2f", distance*0.000621371) + " mi"
        case .cm:
            distanceString = String(format: "%.2f", distance * 100) + " cm"
        }
        
        return "\(distanceString) apart"
    }
}
