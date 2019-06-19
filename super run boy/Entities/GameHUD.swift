//
//  GameHUD.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-15.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class GameHUD : SKSpriteNode, HUDDelegate {
    
    var coinLabel : SKLabelNode
    var superCoinCounter : SKSpriteNode
    
    init(with size: CGSize) {
        coinLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        superCoinCounter = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: size.width * 0.3, height: size.height * 0.8))
        super.init(texture: nil, color: .clear, size: size)
       
        createCoinLabel()
        createSuperCoin()
    }
    
    private func createCoinLabel() {
        coinLabel.verticalAlignmentMode = .center
        coinLabel.text = "0"
        coinLabel.fontSize = 200.0
        coinLabel.scale(to: frame.size, width: false, multiplier: 0.8)
        coinLabel.position = CGPoint(x: frame.maxX - coinLabel.frame.size.width * 2, y: frame.midY)
        coinLabel.zPosition = GameConstants.ZPositions.hud
        addChild(coinLabel)
    }
    
    private func createSuperCoin() {
        superCoinCounter.position = CGPoint(x: frame.minX + superCoinCounter.size.width / 3, y: frame.midY)
        superCoinCounter.zPosition = GameConstants.ZPositions.hud
        
        for i in 0..<3 {
            let slot = SKSpriteNode(imageNamed: GameConstants.Strings.superCoinImageName)
            
            let slotX = -superCoinCounter.size.width/2 + slot.frame.size.width/2 + CGFloat(i) * superCoinCounter.size.width/3 + superCoinCounter.size.width*0.05
            slot.name = String(i)
            slot.alpha = 0.5
            slot.scale(to: superCoinCounter.size, width: true, multiplier: 0.3)
            slot.position = CGPoint(x: slotX, y: superCoinCounter.frame.midY)
            slot.zPosition = GameConstants.ZPositions.hud
            superCoinCounter.addChild(slot)
        }
        
        addChild(superCoinCounter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("nope")
    }
    
    func updateCoinLabel(coins: Int) {
        coinLabel.text = "\(coins)"
    }
    
    func addSuperCoin(index: Int) {
        let slot = superCoinCounter[String(index)].first as! SKSpriteNode
        slot.alpha = 1.0
    }
}
