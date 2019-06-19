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
  
    public var isJumping : Bool = false
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
        removeAllActions()
        
        switch state {
        case .idle:
            startAnimation(idleFrames)
        case .running:
            startAnimation(runFrames)
        case .jumping:
            startAnimation(jumpFrames, false, false)
        }
    }
    
    private func startAnimation(_ frames : [SKTexture], _ resize: Bool = true, _ restore: Bool = true) {
        if frames.count > 0 {
            self.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.05, resize: resize, restore: restore)))
        } else {
            
            print("no frames to run.")
        }
    }
}
