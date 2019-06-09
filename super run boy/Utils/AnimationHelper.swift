//
//  AnimationHelper.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-08.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class AnimationHelper {
    
    static func loadTextures(from atlas: SKTextureAtlas, with name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        
        for index in 0..<atlas.textureNames.count {
            // Idle_0...Run_9
            let textureName = String(name + String(index))
            textures.append(atlas.textureNamed(textureName))
        }
        
        return textures
    }
}
