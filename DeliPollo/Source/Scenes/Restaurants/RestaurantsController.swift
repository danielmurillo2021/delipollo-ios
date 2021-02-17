//
//  Restaurants.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit

class RestaurantsController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "RestaurantsController"
	static var storyboardName: String = "Restaurants"
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var collectionView: UICollectionView!
	
	private let repository: Repository = Repository()
	
	private var promotions: [Promotion] = [] {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	private var brands: [Brand] = [] {
		didSet {
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareCollectionView()
		prepareUI()
		loadPromotions()
	}
	
	private func prepareCollectionView() {
		collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
			return CollectionLayouts.fullWidth(height: 260)
		}
		collectionView.dataSource = self
		collectionView.register(PromoSliderCell.self)
		collectionView.register(RestaurantCell.self)
	}
	
	private func prepareUI() {
		
		if let name = Session.shared.getUserName() {
			titleLabel.text = "Hola \(name)"
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
	}
	
	private func loadPromotions() {
		repository.getPromotions(cache: { cache in
			self.promotions = cache.data ?? []
		}, completion: { result in
			switch result {
			case .success(let response):
				if let data = response.data {
					self.promotions = data
				}
			case .failure(let error):
				self.processError(error)
			}
			
			self.loadBrands()
		})
		
		repository.getPaymentTypes(cache: {
			print($0)
		}, completion: {
			print($0)
		})
	}
	
	private func loadBrands() {
		repository.getBrands(cache: { cache in
			self.brands = cache.data ?? []
		}, completion: { result in
			switch result {
			case .success(let response):
				if let data = response.data {
					self.brands = data
				}
			case .failure(let error):
				self.processError(error)
			}
		})
	}
}

extension RestaurantsController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		section == 0 ? 1 : brands.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.section == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoSliderCell.reuseIdentifier, for: indexPath) as? PromoSliderCell ?? PromoSliderCell()
			cell.promotions = promotions
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as? RestaurantCell ?? RestaurantCell()
			let brand = brands[indexPath.row]
			cell.nameLabel.text = brand.name
			cell.descriptionLabel.text = brand.slogan
			cell.bannerImageView.setImage(brand.banner)
			cell.logoImageView.setImage(brand.logo)
			cell.secondLogoImageView.setImage(brand.logo)
			cell.addTapGesture(handler: { _ in
				self.mainNavigationController.set(screen: .brand(brand))
			})
			return cell
		}
	}
}
