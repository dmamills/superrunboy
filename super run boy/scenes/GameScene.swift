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
    
    var lastTime : TimeInterval = 0
    var dt : TimeInterval = 0
    var gameState : GameState = .ready {
        willSet {
            switch newValue {
            case .ongoing:
                player.state = .running
            case .ready:
                player.state = .idle
            case .finished:
                player.state = .idle
            default:
                print("default?")
            }
        }
    }
    
    override func didMove(to view: SKView) {
        createLayers()
        load(LEVEL)
        loadTileMap()
        createPlayer()
    }
    
    func createLayers() {
        worldLayer = Layer()
        addChild(worldLayer)
        worldLayer.zPosition = GameConstants.ZPositions.world
        worldLayer.layerVelocity = CGPoint(x: -200.0, y: 0.0)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: CGFloat(0.0), dy: CGFloat(-6.0))
        
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
        addPlayerActions()
    }
    
    func addPlayerActions() {
        let up = SKAction.moveBy(x: 0.0, y: frame.size.height / 4, duration: 0.4)
        up.timingMode = .easeOut
        
        player.createUserData(entry: up, forKey: GameConstants.Strings.jumpUpActionKey)
        
        let move = SKAction.moveBy(x: 0.0, y: player.size.height, duration: 0.4)
        let jump = SKAction.animate(with: player.jumpFrames, timePerFrame: 0.4 / Double(player.jumpFrames.count))
        
        let group = SKAction.group([move, jump])
        player.createUserData(entry: group, forKey: GameConstants.Strings.brakeDescendActionKey)
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
        player.run(player.userData?.value(forKey: GameConstants.Strings.brakeDescendActionKey) as! SKAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .ongoing
        case .ongoing:
            touch = true
            if !player.isJumping {
                jump()
            } else if !brake {
                brakeDescend()
            }
        default:
            break
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
    
            if player.isDead() {
                resetGame()
            }
        }
    }
    
    private func resetGame() {
        player.isJumping = false
        brake = false
        worldLayer.reset()
        player.position = CGPoint(x: frame.midX / 2.0, y: frame.midY)
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
            player.isJumping = false
            brake = false
            player.state = gameState ==  .ready ? .idle : .running
            
         //player has hit finish line
         case GameConstants.PhysicsCategories.player | GameConstants.PhysicsCategories.finish:
            print("Hit finish line")
            //gameState = .finished
            resetGame()
            
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
