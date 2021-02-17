//
// PC GROUP SA
// DeliPollo - CartProductCell.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 12/1/21
// Copyright © 2021. All rights reserved.

import UIKit

class CartProductCell: UITableViewCell, NibLoadable {
	
	static var reuseIdentifier: String = "CartProductCell"
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	@IBOutlet weak var productImageView: UIImageView!
	@IBOutlet weak var quantityLabel: UILabel!
	@IBOutlet weak var optionsLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var subtotalLabel: UILabel!
	@IBOutlet weak var deleteButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
