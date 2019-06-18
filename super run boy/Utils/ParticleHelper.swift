//
//  ParticleHelper.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-10.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class ParticleHelper {
    static func addParticleEffect(name: String, particlePositionRange: CGVector, position: CGPoint) -> SKEmitterNode? {
        guard let emitter = SKEmitterNode(fileNamed: name) else { return nil }
        
        emitter.particlePositionRange = particlePositionRange
        emitter.position = position
        emitter.name = name
        return emitter
    }
    
    static func removeParticleEffect(name: String, from node: SKNode)  {
        let emitters = node[name]
        
        emitters.forEach({ n in
            n.removeFromParent()
        })
    }
}
