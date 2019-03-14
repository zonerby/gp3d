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

enum SceneType: String {
    case menu = "Menu"
    case game = "Game"
}

enum BallState: UInt {
    case basic
    case free
}

class GameViewController: UIViewController {
    
    private var currentSceneName: SceneType = .game
    private var scene: SCNScene!
    private var ball: SCNNode!
    private var allowCameraControl: Bool = true
    private var menuHUDMaterial: SCNMaterial
    {
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
    
    // MARK: - Superclass methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        prepareGameScene()
    }
    
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            return .allButUpsideDown
        }
        else
        {
            return .all
        }
    }
    
    // MARK: - Private functions
    
    // MARK: Gestures handling
    
    @objc private func handleTap(_ gestureRecognize: UIGestureRecognizer)
    {
        updateBall(with: .basic)
    }
    
    @objc private func handlePan(_ gesture: UIGestureRecognizer)
    {
        if (ball.physicsBody?.isAffectedByGravity ?? true) == true
        {
            return
        }
        guard let panGesture = gesture as? UIPanGestureRecognizer else { return }
        
        switch panGesture.state {
        case .ended:
            let velocity = panGesture.velocity(in: self.view)
            let scale: Float = 70.0
            let force = SCNVector3(x: Float(velocity.x)/scale,
                                   y: abs(Float(velocity.y))/scale,
                                   z: Float(velocity.y)/scale)
            let position = SCNVector3(x: 0, y: -0.5, z: 0)
            updateBall(with: .free)
            ball.physicsBody?.applyForce(force,
                                         at: position,
                                         asImpulse: true)
            break
        default:
            break
        }
    }
    
    // MARK: Game scene
    
    private func prepareGameScene()
    {
        currentSceneName = .game
        
        configureScene()
        configureBall()
        configureBasket()
        configureWall()
        configureGestures()
    }
    
    private func configureScene()
    {
        guard let scene = SCNScene(named: "art.scnassets/\(currentSceneName.rawValue).scn") else {return}
        scene.physicsWorld.gravity = SCNVector3(0, -260, 0)
        self.scene = scene
        
        if let scnView = self.view as? SCNView
        {
            scnView.scene = scene
            scnView.showsStatistics = true
            scnView.backgroundColor = UIColor.green
        }
        
        switch currentSceneName {
        case .menu:
            guard let hudNode = scene.rootNode.childNode(withName: "text", recursively: true) else {return}
            hudNode.geometry?.materials = [self.menuHUDMaterial]
            hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float.pi)
            allowCameraControl = false
        default:
            break
        }
    }
    
    private func configureBall()
    {
        guard let ballscn = SCNScene(named: "art.scnassets/ball.scn"),
            let ballNode = ballscn.rootNode.childNode(withName: "BASKET_BALL", recursively: true) else {return}
        let baseScale: Float = 0.15
        ballNode.scale = SCNVector3(x:baseScale, y:baseScale, z:baseScale)
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        body.mass = 0.6237
        body.friction = 1.0
        body.rollingFriction = 0.01
        body.restitution = 1
        ballNode.physicsBody = body
        ball = ballNode
        updateBall(with: .basic)
        scene.rootNode.addChildNode(ball)
    }
    
    private func configureBasket()
    {
        guard let basket = scene.rootNode.childNode(withName: "basket", recursively: true) else {return}
        basket.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
    }
    
    private func configureWall()
    {
        guard let wall = scene.rootNode.childNode(withName: "wall", recursively: true) else {return}
        wall.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
    }
    
    private func configureGestures()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func updateBall(with state: BallState)
    {
        guard let physicsBody = ball.physicsBody else { return }
        switch state
        {
        case .free:
            physicsBody.isAffectedByGravity = true
            break
        default:
            physicsBody.velocity = SCNVector3()
            physicsBody.isAffectedByGravity = false
            physicsBody.angularVelocity = SCNVector4()
            ball.position = SCNVector3(x:0, y:35, z:-20)
            break
        }
    }
}
