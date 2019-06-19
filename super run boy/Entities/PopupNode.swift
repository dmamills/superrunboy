//
//  PopupNode.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-15.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

class PopupNode : SKSpriteNode {
    
    var buttonHandlerDelegate : PopupButtonHandlerDelegate
    
    init(withTitle title: String, texture : SKTexture, buttonHandlerDelegate : PopupButtonHandlerDelegate) {
        self.buttonHandlerDelegate = buttonHandlerDelegate
        super.init(texture: texture, color: .clear, size: texture.size())
        
        let bannerLabel = BannerLabel(withTitle: title)
        bannerLabel.scale(to: size, width: true, multiplier: 1.1)
        bannerLabel.zPosition = GameConstants.ZPositions.hud
        bannerLabel.position = CGPoint(x: frame.midX, y: frame.maxY)
        addChild(bannerLabel)
    }
    
    func add(buttons: [Int]) {
        let scalar = 1.0 / CGFloat(buttons.count - 1)
        for (index, button) in buttons.enumerated() {
            let buttonToAdd = SpriteKitButton(defaultButtonImage: GameConstants.Strings.popupButtonNames[button], action: buttonHandlerDelegate.popupButton, index: button)
            
            buttonToAdd.position = CGPoint(x: -frame.maxX/2 + CGFloat(index) * scalar * (frame.size.width*0.5),y: frame.minY)
            buttonToAdd.zPosition = GameConstants.ZPositions.hud
            buttonToAdd.scale(to: frame.size, width: true, multiplier: 0.25)
            
            addChild(buttonToAdd)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
}
