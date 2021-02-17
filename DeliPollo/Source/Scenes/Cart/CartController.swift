//
//  CartController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import UIKit

class CartController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "CartController"
	static var storyboardName: String = "Cart"
	
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var tableView: CartTableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareUI() {
		
		tableView.start()
		tableView.cartTableViewDelegate = self
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
	}
}

extension CartController: CartTableViewDelegate {
	
	func didSetGroups(_ count: Int) {
		if count == 0 {
			mainNavigationController.showPlaceholder("¡todavía no hay ordenes!")
		} else {
			mainNavigationController.hidePlaceholder()
		}
	}
	
	func willProcessCartGroup(_ group: CartGroup) {
		if Session.shared.userIsAuthenticated() {
			CheckoutManager.shared.setGroup(group)
			mainNavigationController.set(screen: .selectAddress)
		} else {
			self.mainNavigationController.loginAlert()
		}
	}
	
	func didSelectCartProduct(_ product: Producto) {
		self.mainNavigationController.set(screen: .updateProductInCart(product))
	}
}
