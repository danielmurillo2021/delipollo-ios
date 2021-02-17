//
//  AddressCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 28/12/20.
//

import UIKit

class AddressCell: UITableViewCell, NibLoadable {
	
	static var reuseIdentifier: String {
		"AddressCell"
	}
	
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var starView: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		backgroundColor = .clear
		selectionStyle = .none
    }
    
}
