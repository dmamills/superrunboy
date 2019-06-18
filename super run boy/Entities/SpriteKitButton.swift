//
//  SpriteKitButton.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-15.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class SpriteKitButton : SKSpriteNode {
    
    var defaultButton : SKSpriteNode
    var action : (Int) -> ()
    var index : Int
    
    init(defaultButtonImage: String, action: @escaping (Int) -> (), index: Int) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        self.action = action
        self.index = index
        
        super.init(texture: nil, color: .clear, size: defaultButton.size)
        
        isUserInteractionEnabled = true
        addChild(defaultButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 0.75
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        
        if defaultButton.contains(location) {
            defaultButton.alpha = 0.75
        } else {
            defaultButton.alpha = 1.0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        
        if defaultButton.contains(location) {
            action(index)
        }
        
        defaultButton.alpha = 1.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 1.0
    }
}
