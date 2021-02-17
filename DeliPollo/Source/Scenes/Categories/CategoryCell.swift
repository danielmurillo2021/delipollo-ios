//
//  CategoryCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 4/1/21.
//

import UIKit

class CategoryCell: UICollectionViewCell, NibLoadable {
	
	static var reuseIdentifier: String = "CategoryCell"
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

}
