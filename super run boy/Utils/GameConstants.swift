//
//  GameConstants.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-08.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//


import Foundation
import CoreGraphics

class GameConstants {
    struct ZPositions {
        static let farBG : CGFloat = 0
        static let closeBG : CGFloat = 1
        static let world : CGFloat = 2
        static let object : CGFloat = 3
        static let player : CGFloat = 4
        static let hud : CGFloat = 5
    }
    
    struct Strings {
        
        static let gameName = "superrunboy"
        
        static let groundTiles = "Ground Tiles"
        static let desertBackground = "DesertBackground"
        static let grassBackground = "GrassBackground"
        static let menuBackground = "preview"
        static let foregroundLayer = "ForegroundLayer"
        static let worldBackgrounds = ["DesertBackground", "GrassBackground", "DesertBackground"]
        
        static let playerName = "player"
        static let playerImage = "Idle_0"
        static let groundNodeName = "ground"
        static let enemyNodeName = "Enemy"
        static let superCoinImageName = "SuperCoin"
        static let fullStar = "StarFull"
        static let emptyStar = "StarEmpty"
        static let superCoinNames = [ "Super1", "Super2", "Super3" ]
        
        static let playButton = "PlayButton"
        static let retryButton = "RetryButton"
        static let menuButton = "MenuButton"
        static let pauseButton = "PauseButton"
        static let emptyButton = "EmptyButton"
        static let cancelButton = "CancelButton"
        static let settingsButton = "SettingsButton"
        static let soundOnButton = "SoundOnButton"
        static let soundMutedButton = "SoundMutedButton"
        static let largePopup = "PopupLarge"
        static let smallPopup = "PopupSmall"
        static let bannerName = "Banner"
        static let popupButtonNames = ["MenuButton", "PlayButton", "RetryButton", "CancelButton"]
        
        static let powerUpName = "PowerUp"
        
        static let scoreScoreKey = "score"
        static let scoreCoinsKey = "coins"
        static let scoreStarsKey = "stars"
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        static let coinRotateAltas = "Coin Rotate Atlas"
        
        static let coinName = "Coin"
        static let coinImageName = "gold0"
        
        static let idlePrefix = "Idle_"
        static let jumpPrefix = "Jump_"
        static let runPrefix = "Run_"
        static let diePrefix = "Die_"
        static let coinPrefix = "gold"
        
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescendActionKey = "BrakeDescend"
        
        static let finishLine = "FinishLine"
        
        static let coinDustEmitter = "CoinDustEmitter"
        static let jumpBrakeEmitter = "JumpBrakeEmitter"
        static let powerUpEmitter = "PowerUpEmitter"
        
        static let font = "UnanimousInverted-BRK-"
        
        static let pausedKey = "Paused"
        static let completedKey = "Completed"
        static let failedKey = "Failed"

        static let musicMuteKey = "music_muted"
        static let soundMuteKey = "sound_muted"
    }

    struct Sounds {
        static let button = "button"
        static let coin = "coin"
        static let completed = "completed"
        static let gameover = "gameover"
        static let powerup = "powerup"
    }
    
    //Bitmasks for physics categories
    struct PhysicsCategories {
        static let none : UInt32 = 0
        static let all : UInt32 = UInt32.max
        static let player : UInt32 = 0x1
        static let ground : UInt32 = 0x1 << 1
        static let finish : UInt32 = 0x1 << 2
        static let collectible : UInt32 = 0x1 << 3
        static let enemy : UInt32 = 0x1 << 4
        static let frame : UInt32 = 0x1 << 5
        static let ceiling : UInt32 = 0x1 << 6
    }
    
    struct Buttons {
        static let menu : Int = 0
        static let play : Int = 1
        static let retry : Int = 2
        static let cancel : Int = 3
        static let nextWorld : Int = 10
        static let previousWorld : Int = 11
        static let levelMenu : Int = 12
    }

    struct DeathReasons {
        static let enemy : Int = 0
        static let fell : Int = 1
    }
}
