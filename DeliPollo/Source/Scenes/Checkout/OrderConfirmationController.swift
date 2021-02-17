//
//  OrderConfirmation.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import UIKit

class OrderConfirmationController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "OrderConfirmationController"
	static var storyboardName: String = "Checkout"
	
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var continueButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		continueButton.onTap {
			self.mainNavigationController.set(screen: .restaurants)
		}
	}
}
