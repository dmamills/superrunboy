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
    let settingsButtonImage = GameConstants.Strings.emptyButton

    //var playerRunning : SKSpriteNode!
    //var player = Player()
    //let playerY : CGFloat = 90.0


    init(size: CGSize, backgroundMusicDelegate : BackgroundMusicDelegate) {
        self.backgroundMusicDelegate = backgroundMusicDelegate
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }

    override func didMove(to view: SKView) {
        layoutView()
       // createDemo()
    }
    
    /*func createDemo() {
        player.loadTextures()
        playerRunning = SKSpriteNode(imageNamed: GameConstants.Strings.playerImage)
        playerRunning.position = CGPoint(x: -20.0, y: playerY)
        playerRunning.zPosition = GameConstants.ZPositions.player
        playerRunning.scale(to: frame.size, width: false, multiplier: 0.1)
        
        addChild(playerRunning)
        
        let runLoop = SKAction.repeatForever(SKAction.animate(with: player.runFrames, timePerFrame: 0.05))
        let idleLoop = SKAction.repeatForever(SKAction.animate(with: player.idleFrames, timePerFrame: 0.05))
        playerRunning.run(runLoop, withKey: "running")
        
        let firstHalf = SKAction.move(to: CGPoint(x: frame.size.width / 2 + 20.0 - playerRunning.size.width / 2, y: playerY), duration: 2.5)
        
        let stopRunning = SKAction.run {
            self.playerRunning.removeAction(forKey: "running")
            self.playerRunning.run(idleLoop, withKey: "idle")
        }
        
        let startRunning = SKAction.run {
            self.playerRunning.removeAction(forKey: "idle")
            self.playerRunning.run(runLoop, withKey: "running")
        }
        
        let resetPlayerPosition = SKAction.run {
            self.playerRunning.position = CGPoint(x: -20.0, y: self.playerY)
        }
        
        let wait = SKAction.wait(forDuration: 1.5)
        let secondHalf = SKAction.move(to: CGPoint(x: frame.size.width + playerRunning.size.width + 20.0, y: playerY), duration: 2.5)
        playerRunning.run(SKAction.repeatForever(SKAction.sequence([firstHalf, stopRunning, wait, startRunning, secondHalf, wait, resetPlayerPosition])))
    }*/
    
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
