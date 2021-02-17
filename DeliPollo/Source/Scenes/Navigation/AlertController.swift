//
//  AlertController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit
import Closures

class AlertController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "AlertController"
	static var storyboardName: String = "Navigation"
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var okButton: UIButton!
	@IBOutlet weak var containerView: UIView!
	
	var message: String!
	var icon: String!
	var okAction: (() -> Void)?
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(named: "loloBlue")?.withAlphaComponent(0.7)
		containerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
		messageLabel.text = message
		imageView.image = UIImage(named: icon)
		
		okButton.onTap {
			if let action = self.okAction {
				action()
			}
			self.dismiss(animated: true, completion: nil)
		}
	}
}
