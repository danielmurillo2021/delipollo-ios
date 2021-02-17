//
//  AccountConfirmationController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 29/12/20.
//

import UIKit

class AccountConfirmationController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "AccountConfirmationController"
	static var storyboardName: String = "Login"
	
	deinit {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func enterButtonTapped(_ sender: Any) {
		DPNavigationController.loadAsync(completion: {
			self.present($0, animated: true, completion: nil)
		})
	}
}
