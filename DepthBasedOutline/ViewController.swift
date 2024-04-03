//
//  ViewController.swift
//  DepthBasedOutline
//
//  Created by Dmitry Bakcheev on 4/3/24.
//



import UIKit
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    @IBOutlet var sceneView: SCNView!
    
    @IBOutlet weak var blueSlider: UISlider!
    @IBAction func blueSliderChanged(_ sender: Any) {
        setColor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The scene in this sample was configured entirely in the max.scn file
        let scene = SCNScene(named: "art.scnassets/Character/max.scn")!
        
        sceneView.scene = scene
        sceneView.showsStatistics = true
        sceneView.delegate = self
        
//        sceneView.allowsCameraControl = true

        let technique = SCNTechnique(dictionary: MyTechnique.techniqueDictionary)
        sceneView.technique = technique
        
        setColor()
    }
    
    /// - Tag: updateAtTime
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
    
    /// - Tag: setColor
    func setColor() {
        DispatchQueue.main.async { [self] in
//            let color = SCNVector3(blueSlider.value, blueSlider.value, blueSlider.value)
//            sceneView.technique?.setValue(color, forKey: "color_weights_symbol")
//
//            let scale = 4
            let scale = blueSlider.value
            let viewSize = sceneView.currentViewport
            sceneView.technique?.setValue(scale, forKey: "scale_symbols")
            sceneView.technique?.setValue(viewSize, forKey: "size_symbols")
           
            
        }
    }
}

