//
//  FavoritesController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit

class FavoritesController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "FavoritesController"
	static var storyboardName: String = "Favorites"
	
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	private var favorites: [Favorite] = []
	private var products: [Product] = [] {
		didSet {
			if products.isEmpty {
				mainNavigationController.showPlaceholder("¡todavía no hay favoritos!")
			} else {
				mainNavigationController.hidePlaceholder()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareUI() {
		tableView.register(ProductCell.self)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
		
		guard let companyId = Session.shared.getBrandCode() else { return }
		
		let decoder = JSONDecoder()
		
		favorites = RealmManager.shared.get(Favorite.self, by: "companyId = '\(companyId)'")
		products = favorites.map { item -> Product in
			let product = try? decoder.decode(Product.self, from: item.data!)
			return product!
		}
	}
	
}

extension FavoritesController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int { 1 }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		products.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell ?? ProductCell()
		
		let product = products[indexPath.row]
		cell.productImageView.setImage(product.image, contentMode: .scaleToFill)
		cell.nameLabel.text = product.title
		cell.priceLabel.text = product.price.currency
		
		cell.addButton.onTap {
			CartManager.shared.addProductWithDefaultOptions(product, completion: { result in
				switch result {
				case .success(let succeeded):
					#if DEBUG
					print(succeeded)
					#endif
				case .failure(let error):
					self.processError(error)
				}
			})
		}
		
		cell.addTapGesture(handler: { _ in
			self.mainNavigationController.set(screen: .productDetail(product))
		})
		
		return cell
	}
}

extension FavoritesController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		UITableView.automaticDimension
	}
}
