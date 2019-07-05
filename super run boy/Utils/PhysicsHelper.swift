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
        case GameConstants.Strings.enemyNodeName:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.enemy
        case GameConstants.Strings.coinName,
             GameConstants.Strings.powerUpName,
             _ where GameConstants.Strings.superCoinNames.contains(name):
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
            sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.collectible
        default:
            sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height))
        }
        
        if name != GameConstants.Strings.playerName {
            sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.player
            sprite.physicsBody!.isDynamic = false
        }
    }

    static func addMovableEnemy(tilemap : SKTileMapNode, sprite : SKSpriteNode, range : Int) {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        
        sprite.physicsBody!.categoryBitMask = GameConstants.PhysicsCategories.enemy
        sprite.physicsBody!.contactTestBitMask = GameConstants.PhysicsCategories.player
        sprite.physicsBody!.isDynamic = false

        // setup action range
        let startingRow = tilemap.tileRowIndex(fromPosition: sprite.position)
        let startingColumn = tilemap.tileColumnIndex(fromPosition: sprite.position)

        var startX : CGPoint?
        var endX : CGPoint?

        //check to make sure range stays on ground tiles
        for i in 0...range {
            if startX == nil {
                if !tileExistsAndIsGround(tilemap: tilemap, atColumn: startingColumn - i, row: startingRow - 1) {
                    startX = tilemap.centerOfTile(atColumn: startingColumn - (i-1), row: startingRow)
                }
            }

            if endX == nil {
                if !tileExistsAndIsGround(tilemap: tilemap, atColumn: startingColumn + i, row: startingRow - 1) {
                    endX = tilemap.centerOfTile(atColumn: startingColumn + (i-1), row: startingRow)
                }
            }
        }

        // if start/end not set, full range is safe
        if startX == nil {
            startX = tilemap.centerOfTile(atColumn: startingColumn - range, row: startingRow)
        }

        if endX == nil {
            endX = tilemap.centerOfTile(atColumn: startingColumn + range, row: startingRow)
        }

        let enemySprites = AnimationHelper.loadTextures(from: SKTextureAtlas(named: GameConstants.Strings.moveableEnemyAtlas), with: GameConstants.Strings.moveableEnemyPrefix)
        sprite.run(SKAction.repeatForever(SKAction.animate(with: enemySprites, timePerFrame: 0.2, resize: false, restore: false)))
        
        // TODO: duration based on range
        let moveLeft = SKAction.move(to: startX!, duration: 1.0)
        let moveRight = SKAction.move(to: endX!, duration: 1.0)
        sprite.run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
    }

    static func tileExistsAndIsGround(tilemap : SKTileMapNode, atColumn : Int, row: Int) -> Bool {
        let nextTile = tilemap.tileDefinition(atColumn: atColumn, row: row)
        if nextTile == nil {
            return false
        }

        guard let isGround = nextTile?.userData?.value(forKey: "ground") as? Bool else { return false }
        return isGround
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
                        let x = CGFloat(platform[0]) * tileSize.width
                        let y = CGFloat(row) * tileSize.height
                        let size = CGSize(width: tileSize.width * CGFloat(platform.count), height: tileSize.height)
                        let gn = GroundNode(with: size)
                        
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
