//
//  String+Extensions.swift
//  super run boy
//
//  Created by Daniel Mills on 2019-06-21.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation

extension String {
    func matches(for regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.count > 0
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}
