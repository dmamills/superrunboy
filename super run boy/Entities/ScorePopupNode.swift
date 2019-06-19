//
//  ScorePopupNode.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-15.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//


import SpriteKit

class ScorePopupNode : PopupNode {
    
    var level : String
    var score : ScoreDictionary
    var scoreLabel : SKLabelNode!
    
    init(buttonHandlerDelegate: PopupButtonHandlerDelegate, title : String, level : String, texture : SKTexture, score: Int, coins: Int, animated: Bool) {
        self.level = level
        self.score = ScoreManager.getCurrentScore(for: level)
        
        super.init(withTitle: title, texture: texture, buttonHandlerDelegate: buttonHandlerDelegate)
        
        addScoreLabel()
        addStars()
        addCoins(count: coins)
        
        if animated {
            animateResult(with: CGFloat(score), and: 100.0)
        } else {
            scoreLabel.text = "\(score)"
            for i in 0..<self.score[GameConstants.Strings.scoreStarsKey]! {
                self[GameConstants.Strings.fullStar + "_\(i)"].first!.alpha = 1.0
            }
        }
    }
    
    func addScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        scoreLabel.fontSize = 200.0
        scoreLabel.text = "0"
        scoreLabel.scale(to: size, width: false, multiplier: 0.1)
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - size.height * 0.6)
        scoreLabel.zPosition = GameConstants.ZPositions.hud
        
        addChild(scoreLabel)
    }
    
    func addStars() {
        for i in 0...2 {
            let empty = SKSpriteNode(imageNamed: GameConstants.Strings.emptyStar)
            let star = SKSpriteNode(imageNamed: GameConstants.Strings.fullStar)
            
            empty.scale(to: size, width: true, multiplier: 0.25)
            empty.position = CGPoint(x: -empty.size.width + CGFloat(i) * empty.size.width, y: frame.maxY - size.height * 0.4)
            if i == 1 {
                empty.position.y += empty.size.height / 4 // push middle star up a bit
            }
            
            empty.zRotation = -CGFloat((-Double.pi/4)/2) + CGFloat(i) * CGFloat((-Double.pi/4)/2)
            empty.zPosition = GameConstants.ZPositions.hud
            
            star.size = empty.size
            star.position = empty.position
            star.zRotation = empty.zRotation
            star.zPosition = GameConstants.ZPositions.hud + 1
            star.name = GameConstants.Strings.fullStar + "_\(i)"
            
            star.alpha = 0.0
            
            addChild(empty)
            addChild(star)
        }
    }
    
    func addCoins(count : Int) {
        let numberOfCoins = count == 4 ? score[GameConstants.Strings.scoreCoinsKey]! : count
        
        let coin = SKSpriteNode(imageNamed: GameConstants.Strings.superCoinImageName)
        coin.scale(to: size, width: false, multiplier: 0.15)
        coin.position = CGPoint(x: -coin.size.width / 1.5, y: frame.maxY - size.height * 0.75)
        coin.zPosition = GameConstants.ZPositions.hud
        
        addChild(coin)
        
        let coinLabel = SKLabelNode(fontNamed: GameConstants.Strings.font)
        coinLabel.verticalAlignmentMode = .center
        coinLabel.fontSize = 200.0
        coinLabel.text = "\(numberOfCoins)/3"
        coinLabel.scale(to: coin.size, width: false, multiplier: 1.0)
        coinLabel.position = CGPoint(x: coin.size.width / 1.5, y: frame.maxY - size.height * 0.75)
        coinLabel.zPosition = GameConstants.ZPositions.hud
        
        addChild(coinLabel)
    }
    
    func animateResult(with achievedScore: CGFloat, and maxScore: CGFloat) {
        var counter = 0
        let wait = SKAction.wait(forDuration: 0.05)
        let count = SKAction.run {
            counter += 1
            self.scoreLabel.text = String(counter)
            
            if CGFloat(counter) / maxScore == 0.8 {
                self.animateStar(number: 2)
            } else if CGFloat(counter) / maxScore == 0.4 {
                self.animateStar(number: 1)
            } else if counter == 1 {
                self.animateStar(number: 0)
            }
        }
        
        let sequence = SKAction.sequence([wait, count])
        self.run(SKAction.repeat(sequence, count: Int(achievedScore)))
    }
    
    func animateStar(number: Int) {
        let star = self[GameConstants.Strings.fullStar + "_\(number)"].first!
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleBack = SKAction.scale(to: 1.0, duration: 0.1)
        star.run(SKAction.group([fadeIn, scaleUp, scaleBack]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no")
    }
}
