//
//  CheckBox.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import UIKit
import Closures

enum CheckBoxType {
	case rounded
	case squared
}

extension CheckBoxType {
	var selectedImage: String {
		self == .squared ? "ic_checked" : "ic_checked_rounded"
	}
	
	var deselectedImage: String {
		self == .squared ? "ic_unchecked" : "ic_unchecked_rounded"
	}
}

class CheckBox: UIImageView {
	
	var type: CheckBoxType = .squared {
		didSet {
			image = UIImage(named: isSelected ? type.selectedImage : type.deselectedImage)
		}
	}
	
	var isSelected: Bool = false {
		didSet {
			image = UIImage(named: isSelected ? type.selectedImage : type.deselectedImage)
		}
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		image = UIImage(named: type.deselectedImage)
		backgroundColor = .clear
		isUserInteractionEnabled = true
		contentMode = .scaleAspectFill
		addTapGesture(handler: { _ in
			self.isSelected.toggle()
		})
	}
	
}
