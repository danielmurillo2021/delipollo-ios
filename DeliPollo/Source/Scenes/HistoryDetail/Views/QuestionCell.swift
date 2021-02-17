//
//  QuestionCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/14/21.
//

import UIKit

class QuestionCell: UITableViewCell, NibLoadable {
    
    static var reuseIdentifier: String {
        "QuestionCell"
    }
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        
        ratingView.backgroundColor = .clear
    }
    
}
