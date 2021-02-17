//
//  ProductsController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import UIKit

class ProductsController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "ProductsController"
	static var storyboardName: String = "Products"
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	var category: Category?
	
	var products: [Product] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	private let repository: Repository = Repository()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareTableView()
		prepareUI()
	}
	
	private func prepareTableView() {
		tableView.register(ProductCell.self)
		tableView.separatorStyle = .none
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	private func prepareUI() {
		if let category = category {
			loadProducts(category: category)
		}
		
		if let brandName = Session.shared.getBrandName(), let brandLogo = Session.shared.getBrandLogo() {
			DispatchQueue.main.async {
				self.titleLabel.text = brandName
				self.imageView.setImage(brandLogo)
			}
		} else {
			self.titleLabel.text = kEmptyString
			self.imageView.image = nil
		}
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
	}
	
	private func loadProducts(category: Category) {
		repository.getProducts(cache: { cache in
			if let data = cache.data {
				self.products = data.filter({ $0.categoryId == category.code })
			}
		}, completion: { result in
			switch result {
			case .success(let response):
				if let data = response.data {
					self.products = data.filter({ $0.categoryId == category.code })
				}
			case .failure(let error):
				self.processError(error)
			}
		})
	}
}

extension ProductsController: UITableViewDataSource {
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
			self.showSpinner()
			CartManager.shared.addProductWithDefaultOptions(product, completion: { [weak self] result in
				self?.hideSpinner()
				switch result {
				case .success(let succeeded):
					#if DEBUG
					print(succeeded)
					#endif
					self?.toast("Producto agregado al carrito")
				case .failure(let error):
					self?.processError(error)
				}
			})
		}
		
		cell.addTapGesture(handler: { _ in
			self.mainNavigationController.set(screen: .productDetail(product))
		})
		
		return cell
	}
}

extension ProductsController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		UITableView.automaticDimension
	}
}
