//
//  GroundNode.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-08.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class GroundNode : SKSpriteNode {
    
    var isBodyActive : Bool = false {
        didSet {
            physicsBody = isBodyActive ? activeBody! : nil
        }
    }
    private var activeBody : SKPhysicsBody?
    
    init(with size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        
        let initialPoint = CGPoint(x: 0.0, y: size.height)
        let endPoint = CGPoint(x: size.width, y: size.height)
        
        activeBody = SKPhysicsBody(edgeFrom: initialPoint, to: endPoint)
        activeBody!.restitution = 0.0
        activeBody!.categoryBitMask = GameConstants.PhysicsCategories.ground
        activeBody!.collisionBitMask = GameConstants.PhysicsCategories.ground
        
        physicsBody = isBodyActive ? activeBody : nil
        name = GameConstants.Strings.groundNodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}
