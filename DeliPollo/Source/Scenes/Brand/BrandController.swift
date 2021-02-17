//
//  BrandController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 2/1/21.
//

import UIKit

class BrandController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "BrandController"
	static var storyboardName: String = "Restaurants"
	
	var brand: Brand!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var orderView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let brand = brand {
			titleLabel.text = brand.name
			descriptionLabel.text = brand.slogan
			backgroundImageView.setImage(brand.banner)
		}
		
		orderView.addTapGesture(handler: { _ in
			Session.shared.setBrand(self.brand)
			self.mainNavigationController.set(screen: .categories)
		})
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
	}
}
