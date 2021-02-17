//
//  SearchController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 4/1/21.
//

import UIKit

class SearchController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "SearchController"
	static var storyboardName: String = "Search"
	
	@IBOutlet weak var searchTextField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!
	
	private let repository: Repository = Repository()
	
	/// productos filtrados
	private var products: [Product] = [] {
		didSet {
			tableView.reloadData()
			heightConstraint.constant = CGFloat(products.count * 100)
		}
	}
	
	/// todos los productos
	private var allProducts: [Product] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareUI() {
		
		searchTextField.delegate = self
		heightConstraint.constant = 0
		
		tableView.separatorStyle = .none
		tableView.register(ProductCell.self)
		tableView.dataSource = self
		
		repository.getProducts(cache: {
			self.allProducts = $0.data ?? []
		}, completion: { result in
			switch result {
			case let .success(response):
				self.allProducts = response.data ?? []
			case let .failure(error):
				print(error)
			}
		})
		
		view.addTapGesture(handler: { _ in
			self.dismiss(animated: true, completion: nil)
		})
		
		closeButton.onTap {
			self.dismiss(animated: true, completion: nil)
		}
	}
	
}

extension SearchController: UITableViewDataSource {
	
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
			self.dismiss(animated: true, completion: nil)
		})
		
		return cell
	}
}

extension SearchController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		UITableView.automaticDimension
	}
}

extension SearchController: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let text = textField.text, let brandCode = Session.shared.getBrandCode() {
			let searchText = text.appending(string)
			
			if searchText.count > 1 {
				products = allProducts.filter({
					$0.title.lowercased().contains(searchText.lowercased()) && $0.brandCode == brandCode
				})
			} else {
				products = []
			}
		}
		return true
	}
	
}
