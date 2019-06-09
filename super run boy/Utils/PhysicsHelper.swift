//
//  PhysicsHelper.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-07.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class PhysicsHelper {
    static func addBody(to sprite: SKSpriteNode, with name: String) {
        switch name {
        case GameConstants.Strings.playerName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width / 2, height: sprite.size.height))
            sprite.physicsBody!.restitution = 0.0
            sprite.physicsBody!.allowsRotation = false
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.player
            sprite.physicsBody!.collisionBitMask = GameConstants.PhysicsCategories.ground | GameConstants.PhysicsCategories.finish
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.all
        case GameConstants.Strings.finishLine:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.finish
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
        }
    }
    
    static func addBody(to tileMap : SKTileMapNode, with name : String) {
        let tileSize = tileMap.tileSize
        
        for row in 0..<tileMap.numberOfRows {
            var tiles = [Int]()
            for column in 0..<tileMap.numberOfColumns {
                let tileDef = tileMap.tileDefinition(atColumn: column, row: row)
                let isUsedTile = tileDef?.userData?[name] as? Bool
                if (isUsedTile ?? false) {
                    tiles.append(1)
                } else {
                    tiles.append(0)
                }
            }
            
            //check if any ground tiles found in row
            if tiles.contains(1) {
                var platform = [Int]()
                
                for (index, tile) in tiles.enumerated() {
                    
                    if tile == 1 && index < (tileMap.numberOfColumns - 1) {
                        platform.append(index)
                    } else if !platform.isEmpty {
                        //we have a platform to create.
                        //print(platform)
                        let x = CGFloat(platform[0]) * tileSize.width
                        let y = CGFloat(row) * tileSize.height
                        
                        let gn = GroundNode(with: CGSize(width: tileSize.width * CGFloat(platform.count), height: tileSize.height))
                        
                        gn.position = CGPoint(x: x, y: y)
                        gn.anchorPoint = CGPoint.zero
                        
                        tileMap.addChild(gn)
                        //remove all entries for next loop
                        platform.removeAll()
                    }
                }
            }
        }
    }
}
