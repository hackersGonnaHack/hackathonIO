/*
 1) OBJ to usdz: xcrun usdz_converter Wineglass.obj Wineglass.usdz
 1) Or use "Vectary".
 
 2) usdz to scn: editor->conver to scene kit scene format
 
 3) decrease size!!
 
 
 
 */

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var headNode: SCNNode=SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene.rootNode.addChildNode(headNode)
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "xx", bundle: Bundle.main)
        {
            configuration.detectionImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            print("Images Succesfully Added.")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        sceneView.addGestureRecognizer(tap)
        sceneView.session.run(configuration)
        
    }
    @objc func handleTap(rec: UITapGestureRecognizer){
        
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                print(tappedNode?.name)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
  
    func createNewNode(name:String,x:Float,y:Float,z:Float) -> SCNNode
    {
        
        let fontScale = Float(0.003)
        let geoText = SCNText(string: name, extrusionDepth: 5)
        geoText.font = UIFont (name: "KohinoorTelugu-Regular", size: CGFloat(300))
        geoText.firstMaterial!.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: geoText)
        textNode.isHidden = false
        textNode.scale = SCNVector3(fontScale, fontScale, fontScale)
        
        let (min, max) = (geoText.boundingBox.min, geoText.boundingBox.max)
        let width = (max.x - min.x) * fontScale
        let height = (max.y - min.y) * fontScale
        
        let textPlane = SCNPlane(width: CGFloat(width), height: CGFloat(height))
        let planeNode = SCNNode(geometry: textPlane)
        planeNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        //textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        textNode.position = SCNVector3(x: x, y: y, z: z)
        // x sağa
        // y ileri
        // z yukarı
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear.withAlphaComponent(0)
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.position = textNode.position
        textNode.eulerAngles = planeNode.eulerAngles
        
        //planeNode.position = SCNVector3(x.columns.3.x , x.columns.3.y , x.columns.3.z)
        planeNode.name = name
        
        planeNode.addChildNode(textNode)
        planeNode.isHidden = false
        planeNode.eulerAngles.x = .pi/2
        return planeNode
    }
    
    

    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
    
        if anchor is ARImageAnchor
        {
            var anchorPos = anchor.transform.columns.3
            
            headNode.position.x = anchorPos.x
            headNode.position.y = anchorPos.y
            headNode.position.z = anchorPos.z
            
            let fontScale = Float(0.003)
            let geoText = SCNText(string: "", extrusionDepth: 5)
            geoText.font = UIFont (name: "KohinoorTelugu-Regular", size: CGFloat(300))
            geoText.firstMaterial!.diffuse.contents = UIColor.white
            
            let textNode = SCNNode(geometry: geoText)
            textNode.isHidden = false
            textNode.scale = SCNVector3(fontScale, fontScale, fontScale)
            
            let (min, max) = (geoText.boundingBox.min, geoText.boundingBox.max)
            let width = (max.x - min.x) * fontScale
            let height = (max.y - min.y) * fontScale
            
            let textPlane = SCNPlane(width: CGFloat(width), height: CGFloat(height))
            let planeNode = SCNNode(geometry: textPlane)
            planeNode.scale = SCNVector3(0.5, 0.5, 0.5)
            
            let dx = min.x + 0.5 * (max.x - min.x)
            let dy = min.y + 0.5 * (max.y - min.y)
            let dz = min.z + 0.5 * (max.z - min.z)
            textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
            
            
            planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear.withAlphaComponent(0)
            planeNode.geometry?.firstMaterial?.isDoubleSided = true
            planeNode.position = textNode.position
            textNode.eulerAngles = planeNode.eulerAngles
            
            //planeNode.position = SCNVector3(x.columns.3.x , x.columns.3.y , x.columns.3.z)
            planeNode.name = "name"
            
            planeNode.addChildNode(textNode)
            planeNode.isHidden = false
            headNode.addChildNode(planeNode)
            

            //headNode.eulerAngles.x = -.pi/2
            //node.addChildNode(planeNode)
            
            
            
            // x sağa
            // y ileri
            // z yukarı
            
            headNode.addChildNode(createNewNode(name: "Front Right", x: Float(1.5), y: Float(0.9), z: Float(-0.5)))
            headNode.addChildNode(createNewNode(name: "Front Left", x: Float(-0.5), y: Float(0.9), z: Float(-0.5)))
            
            
            headNode.addChildNode(createNewNode(name: "Rear Right", x: Float(1.5), y: Float(-2), z: Float(-0.5)))
            headNode.addChildNode(createNewNode(name: "Rear Left", x: Float(-0.5), y: Float(-2), z: Float(-0.5)))

            
        }
        
        return headNode
    }
    
    @objc func didTap(sender: UITapGestureRecognizer){
        print("hai")
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Called when any node has been added to the anchor
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // This method will help when any node has been removed from sceneview
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let x = anchor.transform
        headNode.position = SCNVector3(x.columns.3.x, x.columns.3.y , x.columns.3.z)
        headNode.eulerAngles.x = -.pi/2
    }
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // help us inform the user when the app is ready
    }
}
