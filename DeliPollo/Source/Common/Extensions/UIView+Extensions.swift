//
//  UIView+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit

extension UIView {
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderColor = UIColor.loloBlue.cgColor
			layer.borderWidth = newValue
		}
	}
	
	func setLayerCorners(radius: CGFloat, topLeftCorner: Bool = false, topRightCorner: Bool = false, bottomLeftCorner: Bool = false, bottomRightCorner: Bool = false) {
			
		var corners = CACornerMask()
		
		if topLeftCorner { corners.insert(.layerMinXMinYCorner) }
		if topRightCorner { corners.insert(.layerMaxXMinYCorner) }
		if bottomLeftCorner { corners.insert(.layerMinXMaxYCorner) }
		if bottomRightCorner { corners.insert(.layerMaxXMaxYCorner) }
		
		self.layer.cornerRadius = radius
		self.layer.maskedCorners = corners
	}
}
