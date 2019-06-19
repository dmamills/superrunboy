//
//  MenuScene.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-18.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene {
    
    var sceneManagerDelegate : SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        layoutView()
    }
    
    func layoutView() { 
        let titleLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        titleLabel.text = GameConstants.Strings.gameName
        titleLabel.fontSize = 200.0
        titleLabel.fontColor = .white
        titleLabel.scale(to: frame.size, width: true, multiplier: 0.8)
        titleLabel.zPosition = GameConstants.ZPositions.hud
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.75 - titleLabel.frame.size.height / 2)
        
        addChild(titleLabel)
        
        let startButton = SpriteKitButton(defaultButtonImage: GameConstants.Strings.playButton, action: goToLevelScene, index: 0)
        startButton.scale(to: frame.size, width: false, multiplier: 0.1)
        startButton.position = CGPoint(x: frame.midX, y: frame.minY + startButton.frame.size.height * 2)
        startButton.zPosition = GameConstants.ZPositions.hud
        
        addChild(startButton)
    }
    
    func goToLevelScene(_ : Int) {
        sceneManagerDelegate?.presentLevelScene(for: 0)
    }
}
