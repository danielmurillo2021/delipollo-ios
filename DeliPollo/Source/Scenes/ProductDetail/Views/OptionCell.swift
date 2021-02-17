//
//  OptionCellCollectionViewCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 7/1/21.
//

import UIKit

class OptionCell: UICollectionViewCell, NibLoadable {
	
	static var reuseIdentifier: String = "OptionCell"
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var iconView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
