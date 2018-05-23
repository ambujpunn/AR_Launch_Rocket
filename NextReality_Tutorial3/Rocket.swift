//
//  Rocket.swift
//  NextReality_Tutorial3
//
//  Created by Ambuj Punn on 5/23/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Rocket: SCNNode {
    
    private var scene: SCNScene!
    
    init(scene: SCNScene) {
        super.init()
        self.scene = scene
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        guard let rocketNode = self.scene.rootNode.childNode(withName: "rocketNode", recursively: true),
            let smokeNode = self.scene.rootNode.childNode(withName: "smokeNode", recursively: true)
            else {
                return
        }
        
        let smoke = SCNParticleSystem(named: "smoke.scnp", inDirectory: nil)
        smokeNode.addParticleSystem(smoke!)
        
        self.addChildNode(rocketNode)
        self.addChildNode(smokeNode)
    }
    
}
