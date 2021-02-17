//
//  LogoutController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit
import Closures

class LogoutController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "LogoutController"
	static var storyboardName: String = "Navigation"
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var okButton: UIButton!
	@IBOutlet weak var noButton: UIButton!
	@IBOutlet weak var containerView: UIView!
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(named: "loloBlue")?.withAlphaComponent(0.7)
		containerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
		
		noButton.onTap {
			self.dismiss(animated: true, completion: nil)
		}
		
		okButton.onTap {
			Session.shared.clear()
			self.navigateToIntro()
		}
	}
	
	private func navigateToIntro() {
		IntroController.loadAsync(completion: {
			self.present($0, animated: true, completion: nil)
		})
	}
}
