//
//  HUDDelegate.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-15.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation

protocol HUDDelegate {
    func updateCoinLabel(coins : Int)
    func addSuperCoin(index: Int)
}
