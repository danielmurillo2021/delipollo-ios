//
//  ProductCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 6/1/21.
//

import UIKit

class ProductCell: UITableViewCell, NibLoadable {
	
	static var reuseIdentifier: String = "ProductCell"
	
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	@IBOutlet weak var productImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var addButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		backgroundColor = .clear
    }
    
}
