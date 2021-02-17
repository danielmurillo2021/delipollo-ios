//
//  CardCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 28/12/20.
//

import UIKit

class CardCell: UITableViewCell, NibLoadable {
	
	static var reuseIdentifier: String {
		"CardCell"
	}
	
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkCard: CheckBox!
	@IBOutlet weak var starView: UIView!
	@IBOutlet weak var deleteButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = .clear
		selectionStyle = .none
	}
	
}
