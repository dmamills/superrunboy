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
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            
            scene.scaleMode = .aspectFill
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
