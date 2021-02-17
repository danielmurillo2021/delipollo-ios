//
//  HistoryCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/13/21.
//

import UIKit

class HistoryCell: UITableViewCell, NibLoadable {
    
    static var reuseIdentifier: String {
        "HistoryCell"
    }
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var arrowButton: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
}
