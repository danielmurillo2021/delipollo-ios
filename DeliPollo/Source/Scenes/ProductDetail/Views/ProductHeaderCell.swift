//
//  ProductHeaderCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 8/1/21.
//

import UIKit

class ProductHeaderCell: UICollectionViewCell {
	
	static let reuseIdentifier: String = "ProductHeaderCell"
	
	@IBOutlet weak var productImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
}
