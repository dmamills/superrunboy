//
//  ScoreManager.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-15.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation

typealias ScoreDictionary = [String : Int]

let coinsKey = GameConstants.Strings.scoreCoinsKey
let scoreKey = GameConstants.Strings.scoreScoreKey
let starsKey = GameConstants.Strings.scoreStarsKey
let totalKey = GameConstants.Strings.scoreTotalKey

struct ScoreManager {
    static func getCurrentScore(for levelKey : String) -> ScoreDictionary {
        if let existingData = UserDefaults.standard.dictionary(forKey: levelKey) as? ScoreDictionary {
            return existingData
        }
        
        return [
            coinsKey: 0,
            scoreKey: 0,
            starsKey: 0,
            totalKey: 100,
        ]
    }
    
    static func updateScore(for levelKey : String, and score: ScoreDictionary) {
        UserDefaults.standard.set(score, forKey: levelKey)
        UserDefaults.standard.synchronize()
    }
    
    static func compare(scores: [ScoreDictionary], in levelKey: String) {
        var newHighscore = false
        let currentScore = getCurrentScore(for: levelKey)
        var maxCoins = currentScore[coinsKey]
        var maxScore = currentScore[scoreKey]
        var maxStars = currentScore[starsKey]
        var totalCoin = currentScore[totalKey]
        
        for score in scores {
            if score[coinsKey]! > maxCoins! {
                maxCoins = score[coinsKey]
                newHighscore = true
            }
            
            if(score[starsKey]! > maxStars!) {
                maxStars = score[starsKey]
                newHighscore = true
            }
            
            if(score[scoreKey]! > maxScore!) {
                maxScore = score[scoreKey]
                newHighscore = true
            }

            if(score[totalKey] != totalCoin!) {
                totalCoin = score[totalKey]
            }
        }
        
        if newHighscore {
            updateScore(for: levelKey, and: [
                scoreKey: maxScore!,
                coinsKey: maxCoins!,
                starsKey: maxStars!,
                totalKey: totalCoin!
            ])
        }
    }
}
