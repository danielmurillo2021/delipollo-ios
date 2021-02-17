//
//  ProductDetailController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import UIKit

class ProductDetailController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "ProductDetailController"
	static var storyboardName: String = "Products"
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var collectionView: ProductCollectionView!
	
	private var quantity: Int = 1
	
	private let repository: Repository = Repository()
	
	/// Producto nuevo que se va a agregar
	var product: Product?
	
	/// Producto que se va a editar desde el carrito
	var updatingProduct: Producto?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
		loadData()
	}
	
	private func prepareUI() {
		
		collectionView.parentController = self
		
		if let brandName = Session.shared.getBrandName(),
		   let brandLogo = Session.shared.getBrandLogo() {
			DispatchQueue.main.async {
				self.titleLabel.text = brandName
				self.logoImageView.setImage(brandLogo)
			}
		} else {
			self.titleLabel.text = kEmptyString
			self.logoImageView.image = nil
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
	
	private func loadData() {
		if let product = product {
			repository.getProduct(productId: product.code, companyId: product.companyCode, completion: { [weak self] result in
				switch result {
				case .success(let response):
					if let data = response.data {
						self?.collectionView.setProduct(data, quantity: 1)
					}
				case .failure(let error):
					self?.processError(error)
				}
			})
		}
		
		if let producto = updatingProduct,
		   let companyId = producto.codEmpresa {
			repository.getProduct(productId: producto.codProducto, companyId: companyId, completion: { [weak self] result in
				switch result {
				case .success(let response):
					if let data = response.data {
						self?.collectionView.setProduct(data, quantity: producto.cantidad, updatingProduct: producto)
					}
				case .failure(let error):
					self?.processError(error)
				}
			})
		}
	}
}
