//
//  SceneManagerDelegate.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-18.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation

protocol SceneManagerDelegate {
    func presentLevelScene(for world: Int)
    func presentGameScene(for level: Int, in world: Int)
    func presentMenuScene()
}
