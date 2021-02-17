//
//  ProductFooterCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 8/1/21.
//

import UIKit

class ProductFooterCell: UICollectionViewCell {
	
	static let reuseIdentifier: String = "ProductFooterCell"
	
	var quantity: Int = 0
	
	@IBOutlet weak var observationTextView: UITextView!
	@IBOutlet weak var substractButton: UIButton!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var buyButton: UIButton!
	@IBOutlet weak var quantityLabel: UILabel!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		prepareUI()
	}
	
	private func prepareUI() {
		
		updateLabel()
		
		substractButton.onTap {
			if self.quantity > 1 {
				self.quantity -= 1
				self.updateLabel()
			}
		}
		
		addButton.onTap {
			if self.quantity < 1000 {
				self.quantity += 1
				self.updateLabel()
			}
		}
	}
	
	private func updateLabel() {
		quantityLabel.text = quantity.description
	}
}
