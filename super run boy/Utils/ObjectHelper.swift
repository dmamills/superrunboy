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
        case GameConstants.Strings.finishLine:
            PhysicsHelper.addBody(to: sprite, with: name)
        default:
            print("\(name) not handled")
        }
    }
}
