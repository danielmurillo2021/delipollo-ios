//
//  LoloCodeInserterView.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 23/12/20.
//

import CodeInserterView

class LoloCodeInsertView: CodeInserterView {
	
	init() {
		super.init(numberOfDigitTextFields: .four, spacing: 6)
		prepareUI()
	}
	
	required init(numberOfDigitTextFields: NumberOfDigitTextFields, spacing: CGFloat) {
		super.init(numberOfDigitTextFields: numberOfDigitTextFields, spacing: spacing)
		prepareUI()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
		prepareUI()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		prepareUI()
	}
	
	func prepareUI() {
		borderColor = .loloBlue
		textColor = .loloGray
		textFont = UIFont.bloggerSans(size: 20, bold: true)
	}
}
