//
//  LevelScene.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-18.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class LevelScene : SKScene {
    
    var world : Int!
    var level : Int!
    
    var popupLayer : SKNode!
    var sceneManagerDelegate : SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        layoutScene(for: world)
    }
    
    func layoutScene(for world : Int) {
        let backgroundImage = SKSpriteNode(imageNamed: GameConstants.Strings.worldBackgrounds[world])
        backgroundImage.scale(to: frame.size, width: false, multiplier: 1.0)
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.zPosition = GameConstants.ZPositions.farBG
        addChild(backgroundImage)
        
        
        let titleLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        titleLabel.text = "World \(world+1)"
        titleLabel.scale(to: frame.size, width: true, multiplier: 0.1)
        titleLabel.fontSize = 200.0
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY - titleLabel.frame.size.height * 1.5)
        titleLabel.zPosition = GameConstants.ZPositions.world
        
        addChild(titleLabel)
        
        let menuButton = SpriteKitButton(defaultButtonImage: GameConstants.Strings.menuButton, action: buttonHandler, index: 12)
        menuButton.scale(to: frame.size, width: true, multiplier: 0.2)
        menuButton.position = CGPoint(x: frame.midX, y: frame.minY + menuButton.size.height / 1.5)
        menuButton.zPosition = GameConstants.ZPositions.world
        
        addChild(menuButton)
        
        if world != 0 {
            let worldBackButton = SpriteKitButton(defaultButtonImage: GameConstants.Strings.playButton, action: buttonHandler, index: 11)
            worldBackButton.scale(to: frame.size, width: true, multiplier: 0.075)
            worldBackButton.xScale *= 1
            worldBackButton.position = CGPoint(x: frame.minX + worldBackButton.size.width / 1.5, y: frame.maxY - titleLabel.frame.size.height)
            worldBackButton.zPosition = GameConstants.ZPositions.world
            
            addChild(worldBackButton)
        }
        
        if world < GameConstants.Strings.worldBackgrounds.count - 1 {
            let worldNextButton = SpriteKitButton(defaultButtonImage: GameConstants.Strings.playButton, action: buttonHandler, index: 10)
            worldNextButton.scale(to: frame.size, width: true, multiplier: 0.075)
            worldNextButton.position = CGPoint(x: frame.maxX - worldNextButton.size.width / 1.5, y: frame.maxY - titleLabel.frame.size.height)
            worldNextButton.zPosition = GameConstants.ZPositions.world
            
            addChild(worldNextButton)
        }
        
        var level = 1
        let columnStartingPoint = (frame.midX / 2)
        let rowStartingPoint = frame.midY + frame.midY / 2.5
        
        for row in 0..<3 {
            for column in 0..<3 {
                let levelBox = SpriteKitButton(defaultButtonImage: GameConstants.Strings.emptyButton, action: buttonHandler, index: level)
                levelBox.position = CGPoint(x: columnStartingPoint + CGFloat(column) * columnStartingPoint, y: rowStartingPoint - CGFloat(row) * columnStartingPoint)
                
                levelBox.zPosition = GameConstants.ZPositions.world
                addChild(levelBox)
                
                let levelLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
                levelLabel.fontSize = 180.0
                levelLabel.verticalAlignmentMode = .center
                levelLabel.text = "\(level)"
                
                if !UserDefaults.standard.bool(forKey: "Level_\(world)-\(level)") && level != 1 {
                    levelBox.isUserInteractionEnabled = false
                    levelBox.alpha = 0.75
                }
                
                levelLabel.scale(to: levelBox.size, width: false, multiplier: 0.5)
                levelLabel.zPosition = GameConstants.ZPositions.world
                levelBox.addChild(levelLabel)
                levelBox.scale(to: frame.size, width: true, multiplier: 0.2)
                
                level += 1
            }
        }
    }
    
    func buttonHandler(index : Int) {
        switch index {
        case 1,2,3,4,5,6,7,8,9:
            sceneManagerDelegate?.presentGameScene(for: index, in: world)
            break
        case 10:
            sceneManagerDelegate?.presentLevelScene(for: world + 1)
            break
        case 11: //previous world
            sceneManagerDelegate?.presentLevelScene(for: world - 1)
            break
        case 12: // menu button
            sceneManagerDelegate?.presentMenuScene()
            break
        default:
            break
        }
    }
}

extension LevelScene : PopupButtonHandlerDelegate {
    func popupButton(index: Int) {
        switch index {
        case 1: // play
            sceneManagerDelegate?.presentGameScene(for: level, in: world)
        case 3: // home?
            break
        default:
            break
        }
    }
}
