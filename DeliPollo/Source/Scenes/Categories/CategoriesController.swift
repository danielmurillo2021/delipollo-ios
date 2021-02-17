//
//  Categories.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit

class CategoriesController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "CategoriesController"
	static var storyboardName: String = "Categories"
	
	private let repository = Repository()
	
	private var categories: [Category] = [] {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareCollectionView()
		prepareUI()
	}
	
	private func prepareCollectionView() {
		collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
			return CollectionLayouts.grid
		}
		collectionView.register(CategoryCell.self)
		collectionView.dataSource = self
	}
	
	private func prepareUI() {
		
		accountButton.onTap {
			self.mainNavigationController?.set(screen: .menu)
		}
		
		searchButton.onTap {
			self.mainNavigationController?.set(screen: .search)
		}
		
		loadData()
	}
	
	private func loadData() {
		if let brandId = Session.shared.getBrandCode(),
		   let brandName = Session.shared.getBrandName(),
		   let brandLogo = Session.shared.getBrandLogo() {
			loadCategories(brandId: brandId)
			DispatchQueue.main.async {
				self.nameLabel.text = brandName
				self.logoImageView.setImage(brandLogo)
			}
		} else {
			loadBrands()
		}
	}
	
	private func loadBrands() {
		repository.getBrands(cache: { cache in
			if let brand = cache.data?.first {
				Session.shared.setBrand(brand)
			}
		}, completion: { result in
			switch result {
			case .success(let response):
				if let brand = response.data?.first {
					Session.shared.setBrand(brand)
				}
				self.loadData()
			case .failure(let error):
				self.processError(error)
			}
		})
	}
	
	private func loadCategories(brandId: String) {
		repository.getCategories(cache: { cache in
			if let data = cache.data {
				self.categories = data.filter({ $0.brandId == brandId })
			}
		}, completion: { result in
			switch result {
			case .success(let response):
				if let data = response.data {
					self.categories = data.filter({ $0.brandId == brandId })
				} else {
					self.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self.processError(error)
			}
		})
	}
	
}

extension CategoriesController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell ?? CategoryCell()
		let category = categories[indexPath.row]
		cell.imageView.setImage(category.image)
		cell.nameLabel.text = category.title
		cell.addTapGesture(handler: { _ in
			self.mainNavigationController.set(screen: .products(category))
		})
		return cell
	}
}
