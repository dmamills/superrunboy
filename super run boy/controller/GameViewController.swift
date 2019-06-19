//
//  GameViewController.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-07.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let DEBUG : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMenuScene()
    }
}

extension GameViewController : SceneManagerDelegate {
    
    func presentMenuScene() {
        let scene = MenuScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.sceneManagerDelegate = self
        present(scene: scene)
    }
    
    func presentLevelScene(for world: Int) {
        let scene = LevelScene(size: view.bounds.size)
        scene.world = world
        scene.sceneManagerDelegate = self
        scene.scaleMode = .aspectFill
        present(scene: scene)
    }
    
    func presentGameScene(for level: Int, in world: Int) {
        let scene = GameScene(size: view.bounds.size)
        scene.level = "Level_\(world)-\(level)"
        scene.sceneManagerDelegate = self
        scene.scaleMode = .aspectFill
        present(scene: scene)
    }
    
    func present(scene : SKScene) {
        if let view = self.view as! SKView? {
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            if DEBUG {
                view.showsFPS = true
                view.showsPhysics = true
                view.showsNodeCount = true
            }
        }
    }
}
