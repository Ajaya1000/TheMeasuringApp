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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup scene
        setupScene()
    }
    
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
}

extension ViewController: ARSCNViewDelegate {
    
}
