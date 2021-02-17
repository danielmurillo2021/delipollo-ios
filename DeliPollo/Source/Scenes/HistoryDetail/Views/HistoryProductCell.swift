//
//  HistoryProductCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/14/21.
//

import UIKit

class HistoryProductCell: UITableViewCell, NibLoadable {
    
    static var reuseIdentifier: String {
        "HistoryProductCell"
    }
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImage.layer.cornerRadius = 8.0
        logoImage.clipsToBounds = true
		
        qtyLabel.layer.cornerRadius = qtyLabel.frame.width/2
        qtyLabel.layer.masksToBounds = true
    }
    
}
