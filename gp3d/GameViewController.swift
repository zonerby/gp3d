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

//enum sceneType: String {
//    case Menu = "Menu"
//    case Game = "Game"
//}

class GameViewController: UIViewController {
    
    fileprivate var currentSceneName: String!
    
    fileprivate var ball: SCNNode!
    
    fileprivate var allowCameraControl: Bool = true
    
    private var menuHUDMaterial: SCNMaterial {
        // Create a HUD label node in SpriteKit
        let sceneSize = CGSize(width: 300, height: 200)
        
        let skScene = SKScene(size: sceneSize)
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        let instructionLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        instructionLabel.fontSize = 35
        instructionLabel.text = "З🤡Ж"
        instructionLabel.position.x = sceneSize.width / 2
        instructionLabel.position.y = 115
        skScene.addChild(instructionLabel)
        
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        
        return material
    }
    
    private func prepare(to scene: SCNScene) {
        switch currentSceneName {
        case "Menu":
            let hudNode = scene.rootNode.childNode(withName: "text", recursively: true)!
            hudNode.geometry?.materials = [self.menuHUDMaterial]
            hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float.pi) //try 2 replace Float.pi w/ 0
            allowCameraControl = false
        case "Game":
            break
        default:
            print("eto defolt ty noob")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // choose new scene type
        //let menuScene = "Menu"
        let gameScene = "Game"
        
        currentSceneName = gameScene
        
        let scene = SCNScene(named: "art.scnassets/\(currentSceneName.description).scn")!
        
        //custom preparations
        prepare(to: scene)
        
        //default preparations
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        //scnView.allowsCameraControl = allowCameraControl
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.green
        
        let ballscn = SCNScene(named: "art.scnassets/ball.scn")!
        self.ball = ballscn.rootNode.childNode(withName: "BASKET_BALL", recursively: true)!
        self.ball.scale = SCNVector3(x:0.15, y:0.15, z:0.15)
        self.ball.position = SCNVector3(x:0,y:86,z:-20)
        self.ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.ball.physicsBody?.mass = 0.6237
        self.ball.physicsBody?.isAffectedByGravity = false
        self.ball.physicsBody?.friction = 1.0
        self.ball.physicsBody?.rollingFriction = 0.01
        scnView.scene?.rootNode.addChildNode(self.ball)
        scnView.scene?.physicsWorld.gravity = SCNVector3(0, -260, 0)
        
        let basket = scene.rootNode.childNode(withName: "basket", recursively: true)!
        basket.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        //let swipeGesture = UISwipeGestureRecognizer(target: self, action: nil)
    }
    
    @objc func handlePan(_ gesture: UIGestureRecognizer)
    {
        guard let panGesture = gesture as? UIPanGestureRecognizer else { return }
        
        switch panGesture.state {
        case .ended:
            let velocity = panGesture.velocity(in: self.view)
            
            self.ball.physicsBody?.isAffectedByGravity = true
            
            let scale: Float = 70.0
            let force = SCNVector3(x: Float(velocity.x)/scale, y: abs(Float(velocity.y))/scale , z: Float(velocity.y)/scale)
            let position = SCNVector3(x: 0, y: 0, z: 0)
            self.ball.physicsBody?.applyForce(force,
                                              at: position, asImpulse: true)
            break
        default:
            break
        }
        
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
            let node = hitResults[0].node
            
            self.ball.physicsBody?.velocity = SCNVector3(0, 0, 0)
            self.ball.physicsBody?.isAffectedByGravity = false
            self.ball.physicsBody?.angularVelocity = SCNVector4()
            self.ball.position = SCNVector3(x:0,y:86,z:-20)
            
            // get its material
            let material = node.geometry!.firstMaterial!
            
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
