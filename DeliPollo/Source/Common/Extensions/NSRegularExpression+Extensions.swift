//
//  NSRegularExpression+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 10/31/20.
//  Copyright © 2020 Daniel Murrillo. All rights reserved.
//

import Foundation

extension NSRegularExpression {
	
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
	
	func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
