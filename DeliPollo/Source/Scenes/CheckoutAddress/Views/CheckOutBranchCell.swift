//
//  CheckOutBranchCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/11/21.
//

import UIKit

class CheckOutBranchCell: UITableViewCell, NibLoadable {

    static var reuseIdentifier: String {
        "CheckOutBranchCell"
    }
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var branchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
