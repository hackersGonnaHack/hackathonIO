/*
 1) OBJ to usdz: xcrun usdz_converter Wineglass.obj Wineglass.usdz
 1) Or use "Vectary".
 
 2) usdz to scn: editor->conver to scene kit scene format
 
 3) decrease size!!
 
 
 
 */

import UIKit
import SceneKit
import ARKit
import KeychainSwift
import Alamofire

var errorComments = [String]()
var errorNames = [String]()

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var communityBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    
    let keyChain = Global.GlobalVariable.init().keyChain

    var initilize: Bool = true
    var headNode: SCNNode=SCNNode()
    var configuration:ARWorldTrackingConfiguration=ARWorldTrackingConfiguration()
    var nodes:[(name: String, node: SCNNode, active: Bool)] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.layer.cornerRadius = 5
        infoLabel.layer.cornerRadius = 5
        communityBtn.layer.cornerRadius = 5
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.debugOptions = []//[ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.showsStatistics = false
        let scene = SCNScene()
        
        sceneView.scene.rootNode.addChildNode(headNode)
        sceneView.scene = scene
        getError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "xx", bundle: Bundle.main)
        {
            configuration.detectionImages = imageToTrack
            fetchData()
            enableTracking()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if initilize
        {
            
            headNode.position.x = 0
            headNode.position.y = 0
            headNode.position.z = 0
            headNode.eulerAngles.x = -.pi/2
            disableTracking()
            
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
            
            planeNode.addChildNode(textNode)
            headNode.addChildNode(planeNode)
            
            // x sağa
            // y ileri
            // z yukarı
            
            headNode.addChildNode(createNewNode(name:"\(keyChain.get("tirepressurefrontright") ?? "fr") psi", x: Float(1.5), y: Float(0.9), z: Float(-0.5), w: -.pi/4))
            headNode.addChildNode(createNewNode(name: "\(keyChain.get("tirepressurefrontleft") ?? "fl") psi", x: Float(-0.5), y: Float(0.9), z: Float(-0.5), w: .pi/4))
            
            
            headNode.addChildNode(createNewNode(name: "\(keyChain.get("tirepressurerearright") ?? "rr") psi", x: Float(1.5), y: Float(-2), z: Float(-0.5), w: .pi*5/4))
            headNode.addChildNode(createNewNode(name: "\(keyChain.get("tirepressurerearleft") ?? "rl") psi", x: Float(-0.5), y: Float(-2), z: Float(-0.5), w: .pi*3/4))
            
            headNode.addChildNode(createNewNode(name: "\(keyChain.get("fuellevelpercent") ?? "fuel") %", x: Float(-0.5), y: Float(-2), z: Float(0), w: .pi*3/4))
            
            
            headNode.addChildNode(createNewNode(name: "Front Right \(keyChain.get("doorstatusfrontright") ?? "fr")", x: Float(1.5), y: Float(0.6), z: Float(-0.2), w: -.pi/4))
            headNode.addChildNode(createNewNode(name: "Front Left \(keyChain.get("doorstatusfrontleft") ?? "fr")", x: Float(-0.5), y: Float(0.6), z: Float(-0.2), w: .pi/4))
            headNode.addChildNode(createNewNode(name: "Rear Right \(keyChain.get("doorstatusrearright") ?? "fr")", x: Float(1.5), y: Float(-1.7), z: Float(-0.2), w: .pi*5/4))
            headNode.addChildNode(createNewNode(name: "Rear Left \(keyChain.get("doorstatusrearleft") ?? "fr")", x: Float(-0.5), y: Float(-1.7), z: Float(-0.2), w: .pi*3/4))
            sceneView.scene.rootNode.addChildNode(headNode)
            initilize = false
        }
        else
        {
            for (offset: index, element: (name: str, node: node, active: _)) in self.nodes.enumerated()
            {
                    if str.range(of:"OPEN") != nil
                    {
                        if str.range(of:"Front Right") != nil
                        {
                            node.removeFromParentNode()
                            node.removeFromParentNode()
                            headNode.addChildNode(createNewNode(name: "Front Right CLOSED", x: Float(1.5), y: Float(0.6), z: Float(-0.2), w: -.pi/4))
                        }
                        else if str.range(of:"Front Left") != nil
                        {
                            node.removeFromParentNode()
                            headNode.addChildNode(createNewNode(name: "Front Left CLOSED", x: Float(-0.5), y: Float(0.6), z: Float(-0.2), w: .pi/4))
                        }
                        else if str.range(of:"Rear Right") != nil
                        {
                            node.removeFromParentNode()
                            headNode.addChildNode(createNewNode(name: "Rear Right CLOSED", x: Float(1.5), y: Float(-1.7), z: Float(-0.2), w: .pi*5/4))
                        }
                        else if str.range(of:"Rear Left") != nil
                        {
                            node.removeFromParentNode()
                            headNode.addChildNode(createNewNode(name: "Rear Left CLOSED", x: Float(-0.5), y: Float(-1.7), z: Float(-0.2), w: .pi*3/4))
                        }
                        
                    }
                    else if str.range(of:"CLOSED") != nil
                    {
                        if str.range(of:"Front Right") != nil
                        {
                            node.removeFromParentNode()
                            node.removeFromParentNode()
                            headNode.addChildNode(createNewNode(name: "Front Right OPEN", x: Float(1.5), y: Float(0.6), z: Float(-0.2), w: -.pi/4))
                        }
                        else if str.range(of:"Front Left") != nil
                        {
                            node.removeFromParentNode()
                            headNode.addChildNode(createNewNode(name: "Front Left OPEN", x: Float(-0.5), y: Float(0.6), z: Float(-0.2), w: .pi/4))
                            
                        }
                        else if str.range(of:"Rear Right") != nil
                        {
                            node.removeFromParentNode()
                            
                            headNode.addChildNode(createNewNode(name: "Rear Right OPEN", x: Float(1.5), y: Float(-1.7), z: Float(-0.2), w: .pi*5/4))
                            
                        }
                        else if str.range(of:"Rear Left") != nil
                        {
                            node.removeFromParentNode()
                            headNode.addChildNode(createNewNode(name: "Rear Left OPEN", x: Float(-0.5), y: Float(-1.7), z: Float(-0.2), w: .pi*3/4))
                        }
                        
                    }
                    self.nodes[index] = (str, node, false)
                }
        }
    }
    
    
    func fetchData()
    {
        errorLabel.text = "Error Code: P1176"
        infoLabel.text = "Oil Pressure Sensor Malfunction"
    }
    
    func createNewNode(name:String,x:Float,y:Float,z:Float, w: Float) -> SCNNode
    {
        
        let fontScale = Float(0.003)
        let geoText = SCNText(string: name, extrusionDepth: 5)
        geoText.font = UIFont (name: "KohinoorTelugu-Regular", size: CGFloat(300))
        geoText.firstMaterial!.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: geoText)
        textNode.scale = SCNVector3(fontScale, fontScale, fontScale)
        
        let (min, max) = (geoText.boundingBox.min, geoText.boundingBox.max)
        let width = (max.x - min.x) * fontScale
        let height = (max.y - min.y) * fontScale
        
        let textPlane = SCNPlane(width: CGFloat(width), height: CGFloat(height))
        let planeNode = SCNNode(geometry: textPlane)
        planeNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        textNode.position = SCNVector3(x: x, y: y, z: z)
        
        
        
        
        
        // x sağa
        // y ileri
        // z yukarı
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear.withAlphaComponent(0)
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        planeNode.position = textNode.position
        textNode.eulerAngles = planeNode.eulerAngles
        
        planeNode.addChildNode(textNode)
        planeNode.eulerAngles.x = .pi/2
        planeNode.eulerAngles.z = w
        
        nodes.append((name, textNode, false))
        return planeNode
    }
    func enableTracking()
    {
        print("Tracking On")
        configuration.maximumNumberOfTrackedImages = 7
        self.sceneView.session.run(configuration)
    }
    
    func disableTracking()
    {
        print("Tracking Off")
        configuration.maximumNumberOfTrackedImages = 0
        self.sceneView.session.run(configuration)
        
    }
    func getError()
    {
        print("getting Error")
        let parameters: [String: Any] = ["error_code" : "P1176"]
        
        Alamofire.request("https://6qjzgdx21i.execute-api.us-east-2.amazonaws.com/default/get_comments", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .responseJSON { response in
            

            let s = String(describing: response)
            
            let cs = String(s.dropFirst(9))
            let ccs = String(cs.dropLast())
            //let ccs1 = ccs.components(separatedBy: ",")
            var ccs1 = ccs.replacingOccurrences(of: "{", with: "")
            ccs1 = ccs1.replacingOccurrences(of: "}", with: "")
            ccs1 = ccs1.replacingOccurrences(of: "(", with: "")
            ccs1 = ccs1.replacingOccurrences(of: ")", with: "")
            var ccs2 = ccs1.components(separatedBy: ";")
            
            for i in  0...ccs2.count
            {
                if i == ccs2.count - 1
                {
                    break
                }
                print(i)
                print(ccs2.count)
                let ccs3 = ccs2[i].components(separatedBy: "=")
                print("ccs3")
                print(ccs3[1])
                
                if i%4 == 3
                {
                    errorNames.append(ccs3[1].replacingOccurrences(of: "\\", with: ""))
                }
                if i%4 == 0
                {
                    errorComments.append(ccs3[1].replacingOccurrences(of: "\\", with: ""))
                }
            }
           // print(self.errorNames)
           // print(self.errorComments)
           // Global.GlobalVariable.init().names = errorNames
           // Global.GlobalVariable.init().infos = errorComments

        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    {
        if anchor is ARImageAnchor
        {
            disableTracking()
            
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
            
            planeNode.addChildNode(textNode)
            headNode.addChildNode(planeNode)
            
            // x sağa
            // y ileri
            // z yukarı
            
            headNode.addChildNode(createNewNode(name: "Front Right", x: Float(1.5), y: Float(0.9), z: Float(-0.5), w: -.pi/4))
            headNode.addChildNode(createNewNode(name: "Front Left", x: Float(-0.5), y: Float(0.9), z: Float(-0.5), w: .pi/4))
            
            
            headNode.addChildNode(createNewNode(name: "Rear Right", x: Float(1.5), y: Float(-2), z: Float(-0.5), w: .pi*5/4))
            headNode.addChildNode(createNewNode(name: "Rear Left", x: Float(-0.5), y: Float(-2), z: Float(-0.5), w: .pi*3/4))
            
            
            
        }
        
        return headNode
    }
    func getUserVector() -> SCNVector3 { // (direction, position)
        if let frame = self.sceneView.session.currentFrame
        {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return pos
        }
        return SCNVector3(0, 0, -0.3)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {
        // Selections
        if let pointOfView = sceneView.pointOfView
        {
            for (offset: index, element: (name: str, node: node, active: _)) in self.nodes.enumerated()
            {
                let isMaybeVisible = sceneView.isNode(node, insideFrustumOf: pointOfView)
                if isMaybeVisible
                {
                    self.nodes[index] = (str, node, true)
                }
                else
                {
                    self.nodes[index] = (str, node, false)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        headNode.eulerAngles.x = -.pi/2
    }
}
