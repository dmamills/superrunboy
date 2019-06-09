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
    // die idle run jump
    var state : PlayerState = .idle {
        willSet {
            animate(for: newValue)
        }
    }
    
    public var isJumping : Bool = false
    
    // animation textures
    var runFrames = [SKTexture]()
    var idleFrames = [SKTexture]()
    var jumpFrames = [SKTexture]()
    var dieFrames = [SKTexture]()
    
    func loadTextures() {
        idleFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerIdleAtlas), with: GameConstants.Strings.idlePrefix)
        runFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerRunAtlas), with: GameConstants.Strings.runPrefix)
        jumpFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerJumpAtlas), with: GameConstants.Strings.jumpPrefix)
        dieFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.playerDieAtlas), with: GameConstants.Strings.diePrefix)
    }
    
    func animate(for state: PlayerState) {
        removeAllActions()
        
        switch state {
        case .idle:
            startAnimation(idleFrames)
        case .running:
            startAnimation(runFrames)
        case .jumping:
            startAnimation(jumpFrames)
        }
    }
    
    private func startAnimation(_ frames : [SKTexture]) {
        if frames.count > 0 {
            self.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.05, resize: true, restore: true)))
        } else {
            print("no frames to run.")
        }
    }
    
    func isDead() -> Bool {
        return position.y <= 0
    }
}
