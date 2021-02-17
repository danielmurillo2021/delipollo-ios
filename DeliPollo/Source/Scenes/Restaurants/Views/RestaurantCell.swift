//
//  RestaurantCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 2/1/21.
//

import UIKit

class RestaurantCell: UICollectionViewCell, NibLoadable {
	
	static var reuseIdentifier: String = "RestaurantCell"
	
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	@IBOutlet weak var bannerImageView: UIImageView!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var secondLogoImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

}
