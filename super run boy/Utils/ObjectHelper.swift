    //
//  ObjectHelpeer.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-08.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit
    
class ObjectHelper {
    static func handleChild(sprite : SKSpriteNode, with name: String) {
        switch name {
        case GameConstants.Strings.finishLine, GameConstants.Strings.enemyNodeName,
             GameConstants.Strings.powerUpName,
             _ where GameConstants.Strings.superCoinNames.contains(name):
            PhysicsHelper.addBody(to: sprite, with: name)
        default:
            let component = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            if let rows = Int(component[0]), let columns = Int(component[1]) {
                calculateGridWidth(rows, columns, sprite)
            }
        }
    }
    
    static func calculateGridWidth(_ rows : Int, _ columns: Int, _ parent: SKSpriteNode)  {
        parent.color = .clear
        for x in 0..<columns {
            for y in 0..<rows {
                let position = CGPoint(x: x,y: y)
                addCoin(to: parent, at: position, columns: columns)
            }
        }
    }
    
    static func addCoin(to parent: SKSpriteNode, at position: CGPoint, columns: Int) {
        let coin = SKSpriteNode(imageNamed: GameConstants.Strings.coinImageName)
        coin.size = CGSize(width: parent.size.width / CGFloat(columns), height: parent.size.width / CGFloat(columns))
        coin.name = GameConstants.Strings.coinName
        coin.position = CGPoint(x: position.x * coin.size.width + coin.size.width / 2, y: position.y * coin.size.height + coin.size.height / 2)
        
        let coinFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.coinRotateAltas), with: GameConstants.Strings.coinPrefix)
        
        coin.run(SKAction.repeatForever(SKAction.animate(with: coinFrames, timePerFrame: 0.1)))
        
        PhysicsHelper.addBody(to: coin, with: GameConstants.Strings.coinName)
        parent.addChild(coin)
    }
}
