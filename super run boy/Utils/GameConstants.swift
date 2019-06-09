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
        static let groundTiles = "Ground Tiles"
        static let desertBackground = "DesertBackground"
        static let playerName = "player"
        static let playerImage = "Idle_0"
        static let groundNodeName = "ground"
        
        
        static let playerIdleAtlas = "Player Idle Atlas"
        static let playerRunAtlas = "Player Run Atlas"
        static let playerJumpAtlas = "Player Jump Atlas"
        static let playerDieAtlas = "Player Die Atlas"
        
        static let idlePrefix = "Idle_"
        static let jumpPrefix = "Jump_"
        static let runPrefix = "Run_"
        static let diePrefix = "Die_"
        
        static let jumpUpActionKey = "JumpUp"
        static let brakeDescendActionKey = "BrakeDescend"
        
        static let finishLine = "FinishLine"
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
}
