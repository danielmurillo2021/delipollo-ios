//
//  CheckOutAddressCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/11/21.
//

import UIKit

class CheckOutAddressCell: UITableViewCell, NibLoadable {

    static var reuseIdentifier: String {
        "CheckOutAddressCell"
    }
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var checkAddress: CheckBox!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
