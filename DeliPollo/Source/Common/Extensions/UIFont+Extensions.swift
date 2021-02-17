//
//  UIFont+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 23/12/20.
//

import UIKit

extension UIFont {
	
	static func bloggerSans(size: CGFloat, bold: Bool = false) -> UIFont {
		UIFont(name: bold ? "BloggerSans-Bold" : "BloggerSans", size: size)!
	}
}
