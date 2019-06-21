//
//  GameScene.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-07.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

enum GameState {
    case ready, ongoing, paused, finished
}

class GameScene : SKScene {
    var levelKey = "Level_0-1"
    var world : Int
    var level : Int
    
    var worldLayer : Layer!
    var backgroundLayer : RepeatingLayer!
    var foregroundLayer : RepeatingLayer!
    var mapNode : SKNode!
    var tileMap : SKTileMapNode!
    var pauseButton : SpriteKitButton!

    var player : Player!
    var touch = false
    var brake = false
    
    var coins = 0
    var superCoins = 0
    
    var popup : PopupNode?
    var hudDelegate : HUDDelegate?
    var sceneManagerDelegate : SceneManagerDelegate?
    var soundPlayer = SoundPlayer()
    let Buttons = GameConstants.Buttons.self
    
    var lastTime : TimeInterval = 0
    var dt : TimeInterval = 0
    
    var gameState : GameState = .ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseButton!.alpha = 1.0
                pauseEnemies(false)
            case .ready, .finished, .paused:
                player.state = .idle
                pauseButton!.alpha = 0.0
                pauseEnemies(true)
            }
        }
    }
    
    init(size: CGSize, level : Int, world : Int, sceneManagerDelegate : SceneManagerDelegate) {
        self.world = world
        self.level = level
        self.levelKey = "Level_\(world)-\(level)"
        self.sceneManagerDelegate = sceneManagerDelegate
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: CGFloat(0.0), dy: CGFloat(-6.0))
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frame
        createLayers()
        loadLevel(named: levelKey)
        loadTileMap()
        createPlayer()
        addHud()
        
        // BUG fix to enable SKS timeline actions
        isPaused = true
        isPaused = false
    }
    
    func createLayers() {
        worldLayer = Layer()
        addChild(worldLayer)
        worldLayer.zPosition = GameConstants.ZPositions.world
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        
        backgroundLayer = RepeatingLayer()
        addChild(backgroundLayer)
        
        for i in 0...1 {
            let bgImage = SKSpriteNode(imageNamed: GameConstants.Strings.worldBackgrounds[world])
            bgImage.name = String(i)
            bgImage.scale(to: frame.size, width: false, multiplier: 1.0)
            bgImage.anchorPoint = CGPoint.zero
            bgImage.position = CGPoint(x: 0.0 + CGFloat(i) * bgImage.size.width, y: 0.0)
            
            backgroundLayer.addChild(bgImage)
        }
        
        backgroundLayer.zPosition = GameConstants.ZPositions.farBG
        backgroundLayer.layerVelocity = CGPoint(x: -100.0, y: 0.0)
        
        if world == 1 {
            foregroundLayer = RepeatingLayer()
            foregroundLayer.zPosition = GameConstants.ZPositions.hud
            addChild(foregroundLayer)
            
            for i in 0...1 {
                let foregroundImage = SKSpriteNode(imageNamed: GameConstants.Strings.foregroundLayer)
                foregroundImage.name = String(i)
                foregroundImage.scale(to: frame.size, width: false, multiplier: 1/15)
                foregroundImage.anchorPoint = CGPoint.zero
                foregroundImage.position = CGPoint(x: 0.0 + CGFloat(i) * foregroundImage.size.width, y: 0.0)
                foregroundLayer.addChild(foregroundImage)
            }

            foregroundLayer.layerVelocity = CGPoint(x: -300.0, y: 0.0)
        }
    }
    
    func loadLevel(named : String) {
        if let levelNode = SKNode.unarchiveFromFile(levelKey) {
            mapNode = levelNode
            worldLayer.addChild(mapNode)
        }
    }
    
    func loadTileMap() {
        guard let groundTiles = mapNode.childNode(withName: GameConstants.Strings.groundTiles) as? SKTileMapNode else { return }
        tileMap = groundTiles
        tileMap.scale(to: frame.size, width: false, multiplier: 1.0)
        PhysicsHelper.addBody(to: tileMap, with: GameConstants.Strings.groundNodeName)
        
        for child in groundTiles.children {
            if let sprite = child as? SKSpriteNode, sprite.name != nil {
                ObjectHelper.handleChild(sprite: sprite, with: sprite.name!)
            }
        }
    }
    
    func createPlayer() {
        player = Player(imageNamed: GameConstants.Strings.playerImage)
        guard let player = player else { return }
        
        player.position = CGPoint(x: frame.midX / 2.0, y: frame.midY)
        player.scale(to: frame.size, width: false, multiplier: 0.1)
        player.name = GameConstants.Strings.playerName
        PhysicsHelper.addBody(to: player, with: player.name!)
        player.zPosition = 3
        player.state = .idle
        
        //load textures before adding to world
        player.loadTextures()
        player.loadActions(frame.size.height)
        
        addChild(player)
    }
    
    func addHud() {
        let hud = GameHUD(with: CGSize(width: frame.width, height: frame.height * 0.1))
        hud.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.075)
        hud.zPosition = GameConstants.ZPositions.hud
        hudDelegate = hud
        addChild(hud)
        
        pauseButton = SpriteKitButton(defaultButtonImage: GameConstants.Strings.pauseButton, action: buttonHandler, index: 0)
        pauseButton!.scale(to: frame.size, width: false, multiplier: 0.075)
        pauseButton!.position = CGPoint(x: frame.midX, y: frame.maxY - pauseButton.size.height / 0.75)
        pauseButton!.zPosition = GameConstants.ZPositions.hud
        pauseButton!.alpha = 0.0
        addChild(pauseButton)
    }
    
    func buttonHandler(index: Int) {
        if gameState == .ongoing {
            gameState = .paused
            createAndShowPopup(type: 0, title: GameConstants.Strings.pausedKey)
        }
    }
    
    func createAndShowPopup(type : Int, title : String) {
        switch type {
        case 0:
            popup = PopupNode(withTitle: title, texture: SKTexture(imageNamed: GameConstants.Strings.smallPopup), buttonHandlerDelegate: self)
            popup!.add(buttons: [Buttons.menu, Buttons.cancel, Buttons.retry])
            break
        default:
            popup = ScorePopupNode(buttonHandlerDelegate: self, title: title, level: levelKey, texture: SKTexture(imageNamed: GameConstants.Strings.largePopup), score: coins, coins: superCoins, animated: true)
            popup!.add(buttons: [Buttons.menu, Buttons.retry])
            break
        }
        
        popup!.position = CGPoint(x: frame.midX, y: frame.midY)
        popup!.zPosition = GameConstants.ZPositions.hud
        popup!.scale(to: frame.size, width: true, multiplier: 0.8)
        
        addChild(popup!)
    }
    
    func jump() {
        player.isJumping = true
        player.turnGravity(on: false)
        player.state = .jumping
        
        player.run(player.userData?.value(forKey: GameConstants.Strings.jumpUpActionKey) as! SKAction, completion: {
            if self.touch {
                self.player.run(self.player.userData?.value(forKey: GameConstants.Strings.jumpUpActionKey) as! SKAction, completion: {
                  self.player.turnGravity(on: true)
                })
            }
        })
    }
    
    func brakeDescend() {
        brake = true
        player.physicsBody!.velocity.dy = 0.0
        
        if let brakeEmitter = ParticleHelper.addParticleEffect(name: GameConstants.Strings.jumpBrakeEmitter, particlePositionRange: CGVector(dx: 30.0, dy: 30.0), position: CGPoint(x: player.position.x, y: player.position.y - player.size.height/2)) {
            brakeEmitter.zPosition = GameConstants.ZPositions.object
            addChild(brakeEmitter)
            player.run(player.userData?.value(forKey: GameConstants.Strings.brakeDescendActionKey) as! SKAction, completion: {
                ParticleHelper.removeParticleEffect(name: GameConstants.Strings.jumpBrakeEmitter, from: self)
            })
        }
    }
    
    func pauseEnemies(_ pause : Bool) {
        for enemy in tileMap[GameConstants.Strings.enemyNodeName] {
            enemy.isPaused = pause
        }
    }
    
    func handleCollectable(sprite: SKSpriteNode) {
        switch sprite.name! {
        case GameConstants.Strings.coinName,
             _ where GameConstants.Strings.superCoinNames.contains(sprite.name!):
            collectCoin(sprite: sprite)
        case GameConstants.Strings.powerUpName:
            player.activatePowerup(active: true)
            run(soundPlayer.get(name: GameConstants.Sounds.powerup))
            sprite.removeFromParent()
        default:
            break
        }
    }
    
    func collectCoin(sprite: SKSpriteNode) {
        run(soundPlayer.get(name: GameConstants.Sounds.coin))
        if(sprite.name! == GameConstants.Strings.coinName) {
            coins += 1
            hudDelegate!.updateCoinLabel(coins: coins)
        } else {
            superCoins += 1
            for index in 0..<3 {
                if GameConstants.Strings.superCoinNames[index] == sprite.name! {
                    hudDelegate?.addSuperCoin(index: index)
                }
            }
        }
        
        if let coinDust = ParticleHelper.addParticleEffect(name: GameConstants.Strings.coinDustEmitter, particlePositionRange: CGVector(dx: 5.0, dy: 5.0), position: CGPoint.zero) {
            coinDust.zPosition = GameConstants.ZPositions.object
            sprite.addChild(coinDust)
            sprite.run(SKAction.fadeOut(withDuration: 0.4), completion: {
                coinDust.removeFromParent()
                sprite.removeFromParent()
            })
        }
    }

    func die(_ reason : Int) {
        gameState = .finished
        player.turnGravity(on: false)
        player.physicsBody = nil
        var deathAnimation : SKAction!
        switch reason {
        case GameConstants.DeathReasons.enemy:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        case GameConstants.DeathReasons.fell:
            let up = SKAction.moveTo(y: frame.midY, duration: 0.4)
            let wait = SKAction.wait(forDuration: 0.2)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.4)
            deathAnimation = SKAction.sequence([up, wait, down])
        default:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        run(soundPlayer.get(name: GameConstants.Sounds.gameover))

        player.run(deathAnimation) {
            self.player.removeFromParent()
            self.createAndShowPopup(type: 1, title: GameConstants.Strings.failedKey)
        }
    }
    
    func finishGame() {
        run(soundPlayer.get(name: GameConstants.Sounds.completed))
        //Player hit top off linish line
        if player.position.y > frame.size.height * 0.7 {
            coins += 10
        }
        
        gameState = .finished
        var stars = 0
        let percentage = CGFloat(coins) / 100.0
        
        if percentage >= 0.8 {
            stars = 3
        } else if percentage >= 0.4 {
            stars = 2
        } else if coins >= 1 {
            stars = 1
        }
        
        let scores = [
            GameConstants.Strings.scoreScoreKey: coins,
            GameConstants.Strings.scoreStarsKey: stars,
            GameConstants.Strings.scoreCoinsKey: superCoins,
        ]
        
        ScoreManager.compare(scores: [scores], in: levelKey)
        createAndShowPopup(type: 1, title: GameConstants.Strings.completedKey)
        
        if level < 9 {
            let nextLevelKey = "Level_\(world)-\(level+1)_unlocked"
            UserDefaults.standard.set(true, forKey: nextLevelKey)
            UserDefaults.standard.synchronize()
        }
    }

    override func didSimulatePhysics() {
        for node in tileMap[GameConstants.Strings.groundNodeName] {
            guard let groundNode = node as? GroundNode else { return }
            let groundY = (groundNode.position.y + groundNode.size.height) * tileMap.yScale
            let playerY = player.position.y - player.size.height / 3
            groundNode.isBodyActive = playerY > groundY
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready, .paused:
            gameState = .ongoing
        case .ongoing:
            touch = true
            if !player.isJumping {
                jump()
            } else if !brake {
                brakeDescend()
            }
        case .finished:
            print("game done, reset!")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = false
        player.turnGravity(on: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime > 0 {
            dt = currentTime - lastTime
        } else {
            dt = 0
        }
        
        lastTime = currentTime
        
        if gameState == .ongoing {
            worldLayer.update(dt)
            backgroundLayer.update(dt)
            
            if world == 1 {
                foregroundLayer.update(dt)
            }
        }
    }
}

extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Make a bitmask against the two bodies in contact
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        //if it matches player + ground, the player is no longer airborne/jumping
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.ground:
            player.isJumping = false
            brake = false
            player.state = gameState == .ongoing ? .running : .idle
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.finish:
            finishGame()
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.enemy:
            if player.isInvicible { return }
            die(GameConstants.DeathReasons.enemy)
        case  GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.frame:
            physicsBody = nil
            die(GameConstants.DeathReasons.fell)
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.collectible:
            let collectible = contact.bodyA.node?.name == player.name ? contact.bodyB.node : contact.bodyA.node as! SKSpriteNode
            handleCollectable(sprite: collectible as! SKSpriteNode)
        default:
            break;
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        //if the player has lost contact with the ground, they are now in the air/cannot jump
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.ground:
            player.isJumping = true
        default:
            break;
        }
    }
}

extension GameScene : PopupButtonHandlerDelegate {
    func popupButton(index: Int) {
        switch index {
        case Buttons.menu:
            sceneManagerDelegate?.presentMenuScene()
        case Buttons.play:
            sceneManagerDelegate?.presentLevelScene(for: world)
        case Buttons.retry:
            sceneManagerDelegate?.presentGameScene(for: level, in: world)
        case Buttons.cancel:
            popup!.run(SKAction.fadeOut(withDuration: 0.2), completion: {
                self.popup!.removeFromParent()
                self.gameState = .ongoing
            })
            break
        default:
            print("Unknown button index: \(index)")
        }
    }
}
