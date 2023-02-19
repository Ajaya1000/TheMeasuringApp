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
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // create plane with the "PlaneAnchor"
                let plane = Plane(anchor: planeAnchor)
                // add to the detected
                node.addChildNode(plane)
            }
        }
    }
}
