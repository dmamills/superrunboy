//
//  Player.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-07.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

enum PlayerState {
    case idle, running, jumping
}

class Player : SKSpriteNode {
  
    var isJumping : Bool = false
    var isInvicible : Bool = false
    
    var runFrames = [SKTexture]()
    var idleFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    
    var state : PlayerState = .idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerIdleAtlas), with: GameConstants.Strings.idlePrefix)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerRunAtlas), with: GameConstants.Strings.runPrefix)
        jumpFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerJumpAtlas), with: GameConstants.Strings.jumpPrefix)
        dieFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerDieAtlas), with: GameConstants.Strings.diePrefix)
    }
    
    func loadActions(_ windowHeight : CGFloat) {
        let up = SKAction.moveBy(x: 0.0, y: windowHeight / 4, duration: 0.4)
        up.timingMode = .easeOut
        
        createUserData(entry: up, forKey: GameConstants.Strings.jumpUpActionKey)
        
        let move = SKAction.moveBy(x: 0.0, y: size.height, duration: 0.4)
        let jump = SKAction.animate(with: jumpFrames, timePerFrame: 0.4 / Double(jumpFrames.count))
        
        let group = SKAction.group([move, jump])
        createUserData(entry: group, forKey: GameConstants.Strings.brakeDescendActionKey)
    }
    
    func animate(for state: PlayerState) {
        removeAction(forKey: "movement")
        
        switch state {
        case .idle:
            startAnimation(idleFrames)
        case .running:
            startAnimation(runFrames)
        case .jumping:
            startAnimation(jumpFrames, false, false)
        }
    }

    func jump() {
        isJumping = true
        turnGravity(on: false)
        state = .jumping

        run(userData?.value(forKey: GameConstants.Strings.jumpUpActionKey) as! SKAction, completion: {
            self.turnGravity(on: true)
        })
    }

    func brake() {

        physicsBody!.velocity.dy = 0.0

        if let brakeEmitter = ParticleHelper.addParticleEffect(name: GameConstants.Strings.jumpBrakeEmitter, particlePositionRange: CGVector(dx: 30.0, dy: 30.0), position: CGPoint(x: position.x, y: position.y - size.height/2)) {
            brakeEmitter.zPosition = GameConstants.ZPositions.object
            self.parent!.addChild(brakeEmitter)
            run(userData?.value(forKey: GameConstants.Strings.brakeDescendActionKey) as! SKAction, completion: {
                ParticleHelper.removeParticleEffect(name: GameConstants.Strings.jumpBrakeEmitter, from: self.parent!)
            })
        }
    }
    
    func activatePowerup(active : Bool) {
        if active {
            guard let powerUpEffect = ParticleHelper.addParticleEffect(name: GameConstants.Strings.powerUpEmitter, particlePositionRange: CGVector(dx: 0.0, dy: size.height), position: CGPoint(x: -size.width, y: 0.0)) else { return }
            powerUpEffect.zPosition = GameConstants.ZPositions.object
            
            addChild(powerUpEffect)
            isInvicible = true
            run(SKAction.wait(forDuration: 5.0), completion: {
                self.activatePowerup(active: false)
            })
        } else {
            isInvicible = false
            ParticleHelper.removeParticleEffect(name: GameConstants.Strings.powerUpEmitter, from: self)
        }
    }
    
    private func startAnimation(_ frames : [SKTexture], _ resize: Bool = true, _ restore: Bool = true) {
        if frames.count > 0 {
            self.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.05, resize: resize, restore: restore)), withKey: "movement")
        } else {
            print("no frames to run.")
        }
    }
}
