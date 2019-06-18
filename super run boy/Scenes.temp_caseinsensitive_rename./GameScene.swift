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
    
    let LEVEL = "Level_0-1"
    
    var worldLayer : Layer!
    var backgroundLayer : RepeatingLayer!
    var mapNode : SKNode!
    var tileMap : SKTileMapNode!
    
    var player : Player!
    var touch = false
    var brake = false
    
    var coins = 0
    var superCoins = 0
    
    var hudDelegate : HUDDelegate?
    
    var lastTime : TimeInterval = 0
    var dt : TimeInterval = 0
    var gameState : GameState = .ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
                pauseEnemies(false)
            case .ready, .finished, .paused:
                player.state = .idle
                pauseEnemies(true)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: CGFloat(0.0), dy: CGFloat(-6.0))
        
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
        physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frame
        createLayers()
        load(LEVEL)
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
            let bgImage = SKSpriteNode(imageNamed: GameConstants.Strings.desertBackground)
            bgImage.name = String(i)
            bgImage.scale(to: frame.size, width: false, multiplier: 1.0)
            bgImage.anchorPoint = CGPoint.zero
            bgImage.position = CGPoint(x: 0.0 + CGFloat(i) * bgImage.size.width, y: 0.0)
            
            backgroundLayer.addChild(bgImage)
        }
        
        backgroundLayer.zPosition = GameConstants.ZPositions.farBG
        backgroundLayer.layerVelocity = CGPoint(x: -100.0, y: 0.0)
    }
    
    func load(_ level : String) {
        if let levelNode = SKNode.unarchiveFromFile(level) {
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
                //print(sprite.name)
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
        
        addChild(player)
        player.loadActions(frame.size.height)
    }
    
    func addHud() {
        let hud = GameHUD(with: CGSize(width: frame.width, height: frame.height * 0.1))
        hud.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.05)
        hud.zPosition = GameConstants.ZPositions.hud
        hudDelegate = hud
        addChild(hud)
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
        default:
            break
        }
    }
    
    func collectCoin(sprite: SKSpriteNode) {
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

    // 0 == hit enemy, 1 == fell off
    func die(_ reason : Int) {
        gameState = .finished
        player.turnGravity(on: false)
        player.physicsBody = nil
        var deathAnimation : SKAction!
        switch reason {
        case 0:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        case 1:
            let up = SKAction.moveTo(y: frame.midY, duration: 0.4)
            let wait = SKAction.wait(forDuration: 0.2)
            let down = SKAction.moveTo(y: -player.size.height, duration: 0.4)
            deathAnimation = SKAction.sequence([up, wait, down])
        default:
            deathAnimation = SKAction.animate(with: player.dieFrames, timePerFrame: 0.1, resize: true, restore: true)
        }
        player.run(deathAnimation) {
            self.player.removeFromParent()
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
            resetGame()
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
        }
    }
    
    private func resetGame() {
        player.isJumping = false
        touch = false
        brake = false
        PhysicsHelper.addBody(to: player, with: GameConstants.Strings.playerName)
        player.position = CGPoint(x: frame.midX / 2.0, y: frame.midY)
        
        if childNode(withName: GameConstants.Strings.playerName) == nil {
            addChild(player)
        }
        if physicsBody == nil {
            physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.minX, y: frame.minY), to: CGPoint(x: frame.maxX, y: frame.minY))
            physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.frame
        }
        worldLayer.reset()
        gameState = .ready
    }
}

extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Make a bitmask against the two bodies in contact
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        //if it matches player + ground, the player is no longer airborne/jumping
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.ground:
            print("player hit ground")
            player.isJumping = false
            brake = false
            player.state = gameState == .ongoing ? .running : .idle
             
         //player has hit finish line
         case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.finish:
            gameState = .finished
            resetGame()
        case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.enemy:
            die(0)
        case  GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.frame:
            physicsBody = nil
            die(1)
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
