//
//  BannerLabel.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-15.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//


import SpriteKit

class BannerLabel : SKSpriteNode {
    
    init(withTitle title: String) {
        let texture = SKTexture(imageNamed: GameConstants.Strings.bannerName)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        let label = SKLabelNode(fontNamed: GameConstants.Strings.font)
        label.fontSize = 200.0
        label.verticalAlignmentMode = .center
        label.text = title
        label.scale(to: size, width: false, multiplier: 0.3)
        label.zPosition = GameConstants.ZPositions.hud
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
}
