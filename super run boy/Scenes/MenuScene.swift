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
    var backgroundMusicDelegate : BackgroundMusicDelegate?
    var popup : PopupNode!

    let playButtonImage = GameConstants.Strings.playButton
    let settingsButtonImage = GameConstants.Strings.settingsButton

    init(size: CGSize, backgroundMusicDelegate : BackgroundMusicDelegate) {
        self.backgroundMusicDelegate = backgroundMusicDelegate
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }

    override func didMove(to view: SKView) {
        layoutView()
    }

    func layoutView() {
        let background = SKSpriteNode(imageNamed: GameConstants.Strings.menuBackground)
        background.scale(to: frame.size, width: false, multiplier: 1.0)
        background.zPosition = GameConstants.ZPositions.farBG
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        
        addChild(background)
        
        let titleLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        titleLabel.text = GameConstants.Strings.gameName
        titleLabel.fontSize = 200.0
        titleLabel.fontColor = .white
        titleLabel.scale(to: frame.size, width: true, multiplier: 0.8)
        titleLabel.zPosition = GameConstants.ZPositions.hud
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY * 0.75 - titleLabel.frame.size.height / 2)
        
        addChild(titleLabel)
                
        let startButton = SpriteKitButton(defaultButtonImage: playButtonImage, action: goToLevelScene, index: 0)
        startButton.scale(to: frame.size, width: false, multiplier: 0.1)
        startButton.position = CGPoint(x: frame.midX - startButton.frame.size.width, y: frame.minY + startButton.frame.size.height * 3)
        startButton.zPosition = GameConstants.ZPositions.hud
        
        addChild(startButton)

        let settingsButton = SpriteKitButton(defaultButtonImage: settingsButtonImage, action: showSettings, index: 0)
        settingsButton.scale(to: frame.size, width: false, multiplier: 0.1)
        settingsButton.position = CGPoint(x: frame.midX + settingsButton.frame.size.width, y: frame.minY + settingsButton.frame.size.height * 3)
        settingsButton.zPosition = GameConstants.ZPositions.hud

        addChild(settingsButton)
    }
    
    func goToLevelScene(_ level : Int) {
        sceneManagerDelegate?.presentLevelScene(for: 0)
    }

    func showSettings(_ index : Int) {
        if index == 0 {
            popup = SettingsPopupNode(withTitle: "Settings", texture: SKTexture(imageNamed: GameConstants.Strings.smallPopup), buttonHandlerDelegate: self, backgroundMusicDelegate: backgroundMusicDelegate)
            popup!.add(buttons: [3])
            popup!.position = CGPoint(x: frame.midX, y: frame.midY)
            popup!.zPosition = GameConstants.ZPositions.hud + 1
            popup!.scale(to: frame.size, width: true, multiplier: 0.9)

            addChild(popup)
        }
    }
}

extension MenuScene : PopupButtonHandlerDelegate {
    func popupButton(index: Int) {
        switch index {
        case GameConstants.Buttons.cancel:
            popup!.run(SKAction.fadeOut(withDuration: 0.2), completion: {
                self.popup!.removeFromParent()
            })
        default:
            print("bad index \(index)")
        }
    }
}
