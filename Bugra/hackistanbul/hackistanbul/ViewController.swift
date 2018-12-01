//
//  ViewController.swift
//  hackistanbul
//
//  Created by Buğra Altuğ on 1.12.2018.
//  Copyright © 2018 Buğra Altuğ. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var referencePoint:SCNVector3!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "test", bundle: Bundle.main)
        {
            configuration.detectionImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("Images Succesfully Added.")
        }


        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let x = anchor.transform
        referencePoint = SCNVector3(x.columns.3.x, x.columns.3.y , x.columns.3.z)
        print("Reference Point \(referencePoint ?? SCNVector3(1,2,3))")
    }
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        if anchor is ARImageAnchor
        {
            let x = anchor.transform
            referencePoint = SCNVector3(x.columns.3.x, x.columns.3.y , x.columns.3.z)
            print("Reference Point \(referencePoint ?? SCNVector3(4,5,6))")
            let geoText = SCNText(string: "Hello", extrusionDepth: 5)
            geoText.font = UIFont (name: "KohinoorTelugu-Regular", size: CGFloat(300))
            geoText.firstMaterial!.diffuse.contents = UIColor.white
            
            let textNode = SCNNode(geometry: geoText)
            node.addChildNode(setNodeRef("tee", textNode))
        }
        
        return node
    }
    
    func setNodeRef(_ name_: String, _ node: SCNNode) -> SCNNode
    {
        node.isHidden = false
        //test ise
        let scale = Float(0.003)
        node.scale = SCNVector3(scale, scale, scale)
        
        let (min, max) = (node.boundingBox.min, node.boundingBox.max)
        let width = (max.x - min.x)*scale
        let height = (max.y - min.y)*scale
        
        let plane = SCNPlane(width: CGFloat(width), height: CGFloat(height))
        let planeNode = SCNNode(geometry: plane)
        planeNode.scale = SCNVector3(0.5, 0.5, 0.5)
        
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.5)
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.position = node.position
        node.eulerAngles = planeNode.eulerAngles
        
        planeNode.name = name_
        
        planeNode.addChildNode(node)
        planeNode.isHidden = false
        sceneView.scene.rootNode.addChildNode(planeNode)
        
        planeNode.eulerAngles.x = -.pi/2
        return planeNode
    }
}
