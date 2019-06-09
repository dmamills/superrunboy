//
//  SKNode+Extensions.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-07.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        guard let path = Bundle.main.path(forResource: file, ofType: "sks") else {
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let archiver = try NSKeyedUnarchiver(forReadingFrom: Data(contentsOf: url, options: .mappedIfSafe))
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            archiver.requiresSecureCoding = false
            
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? SKNode
            archiver.finishDecoding()
            
            return scene
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func scale(to screenSize: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ?
          (screenSize.width * multiplier) / self.frame.size.width :
          (screenSize.height * multiplier) / self.frame.size.height
        
        self.setScale(scale)
    }
    
    func turnGravity(on value: Bool) {
        physicsBody?.affectedByGravity = value
    }
    
    func createUserData(entry: Any, forKey key: String) {
        if userData == nil {
            let userDataDictonary = NSMutableDictionary()
            userData = userDataDictonary
        }
        
        userData!.setValue(entry, forKey: key)
    }
}
