//
//  GameViewController.swift
//  gp3d
//
//  Created by Artur Artur on 05.07.17.
//  Copyright © 2017 GP F. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    
    var menuHUDMaterial: SCNMaterial {
        // Create a HUD label node in SpriteKit
        let sceneSize = CGSize(width: 300, height: 200)
        
        let skScene = SKScene(size: sceneSize)
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        let instructionLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        instructionLabel.fontSize = 35
        instructionLabel.text = "Ты пидор 🤡"
        instructionLabel.position.x = sceneSize.width / 2
        instructionLabel.position.y = 115
        skScene.addChild(instructionLabel)
        
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        
        return material
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/Menu.scn")!
        
        let hudNode = scene.rootNode.childNode(withName: "text", recursively: true)!
        hudNode.geometry?.materials = [self.menuHUDMaterial]
        hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float.pi)
        
//        let ballscn = SCNScene(named: "art.scnassets/ball.scn")!
//        let ball = ballscn.rootNode.childNode(withName: "BASKET_BALL", recursively: true)!
//        ball.scale = SCNVector3(x:0.1, y:0.1, z:0.1)
//        ball.position = SCNVector3(x:-4.609,y:99.517,z:-7.0)
//        ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
//        ball.physicsBody?.mass = 1.0
//        ball.physicsBody?.friction = 1.0
//        ball.physicsBody?.rollingFriction = 0.01
//
//        scene.rootNode.addChildNode(ball)
        
        // animate the 3d object
        //ball.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.green
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
