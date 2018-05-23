//
//  ViewController.swift
//  NextReality_Tutorial3
//
//  Created by Ambuj Punn on 5/23/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // 4.2
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        // 4.1
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // 5.1
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
        
        // 6.1
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        gestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // 4.3
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // 5.2
    @objc func tapped(gesture: UITapGestureRecognizer) {
        // Get 2D position of touch event on screen
        let touchPosition = gesture.location(in: sceneView)
        
        // 5.3
        // Translate those 2D points to 3D points using hitTest (existing plane)
        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlane)
        
        guard let hitTest = hitTestResults.first else {
            return
        }
        
        addRocket(hitTest)
    }
    
    // 5.4
    func addRocket(_ hitTest: ARHitTestResult) {
        let scene = SCNScene(named: "art.scnassets/rocket.scn")
        let rocketNode = Rocket(scene: scene!)
        rocketNode.name = "Rocket"
        rocketNode.position = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(rocketNode)
    }
    
    // 6.2
    @objc func doubleTapped(gesture: UITapGestureRecognizer) {
        // Get rocket and smoke nodes
        guard let rocketNode = sceneView.scene.rootNode.childNode(withName: "Rocket", recursively: true) else {
            fatalError("Rocket not found")
        }
        
        guard let smokeNode = rocketNode.childNode(withName: "smokeNode", recursively: true) else {
            fatalError("Smoke node not found")
        }
        
        // 1. Remove the old smoke particle from the smoke node
        smokeNode.removeAllParticleSystems()
        
        // 2. Add fire particle to smoke node
        let fireParticle = SCNParticleSystem(named: "art.scnassets/fire.scnp", inDirectory: nil)
        smokeNode.addParticleSystem(fireParticle!)
        
        // 3. Give rocket physics animation capabilities
        rocketNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        rocketNode.physicsBody?.isAffectedByGravity = false
        rocketNode.physicsBody?.damping = 0.0
        rocketNode.physicsBody?.applyForce(SCNVector3(0,100,0), asImpulse: false)
    }
}
