//
//  IntroController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import UIKit

class IntroController: UIViewController, StoryboardLoadable {
	static var storyboardId: String = "IntroController"
	static var storyboardName: String = "Login"
	
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signinButton: UIButton!
	@IBOutlet weak var visitorButton: UIButton!
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		prepareUI()
    }
	
	private func prepareUI() {
		
		Session.shared.clear()
		
		loginButton.onTap {
			let controller = LoginController.loadFromStoryboard()
			controller.modalPresentationStyle = .overFullScreen
			self.present(controller, animated: true, completion: nil)
		}
		
		signinButton.onTap {
			let controller = SigninController.loadFromStoryboard()
			controller.modalPresentationStyle = .overFullScreen
			self.present(controller, animated: true, completion: nil)
		}
		
		visitorButton.onTap {
			let controller = DPNavigationController.loadFromStoryboard()
			controller.modalPresentationStyle = .overFullScreen
			self.present(controller, animated: true, completion: nil)
		}
	}

}
