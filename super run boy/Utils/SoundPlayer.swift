//
//  SoundPlayer.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-19.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class SoundPlayer {

    func get(name: String) -> SKAction {

        if UserDefaults.standard.bool(forKey: GameConstants.Strings.soundMuteKey) {
            return SKAction.wait(forDuration: 0.0)
        }

        return SKAction.playSoundFileNamed(name, waitForCompletion: false)
    }
    
    let buttonSound = SKAction.playSoundFileNamed("button", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coin", waitForCompletion: false)
    let deathSound = SKAction.playSoundFileNamed("gameover", waitForCompletion: false)
    let completedSound = SKAction.playSoundFileNamed("completed", waitForCompletion: false)
    let powerupSound = SKAction.playSoundFileNamed("powerup", waitForCompletion: false)
}
