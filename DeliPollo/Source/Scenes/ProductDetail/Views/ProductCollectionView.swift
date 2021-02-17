//
//  ProductCollectionView.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 7/1/21.
//

import UIKit

class ProductCollectionView: UICollectionView {
	
	var parentController: UIViewController?
	
	private let realmManager: RealmManager = RealmManager.shared
	
	/// Detalle de producto
	private var product: Product?
	
	/// Producto cuando se esta actualizando
	private var updatingProduct: Producto?
	
	/// Modificadores del producto
	private var modifiers: [ModifierWrapper] = []
	
	private var sectionsCount: Int = 0
	private var lastSection: Int = 0
	private var quantity: Int = 1
	
	func setProduct(_ product: Product, quantity: Int, updatingProduct: Producto? = nil) {
		self.product = product
		self.quantity = quantity
		self.updatingProduct = updatingProduct
		
		DispatchQueue.main.async {
			self.prepareUI()
		}
	}
	
	private func prepareUI() {
		
		register(OptionCell.self)
		
		// prepare modifier
		for modifier in product?.modifiers ?? [] {
			var item = ModifierWrapper(
				id: modifier.id,
				title: modifier.title,
				options: [],
				multiChoice: modifier.multipleSelection.boolValue
			)
			
			// prepare options
			for option in modifier.options ?? [] {
				
				// validar si esta seleccionada por defecto
				var isSelected = modifier.defaultOptionCode == option.code
				
				if let updatingProduct = updatingProduct, updatingProduct.opciones.count > 0 {
					// validar si esta seleccionada al actualizar producto del carrito
					let opcionesIDs = updatingProduct.opciones.map({ $0.id })
					isSelected = opcionesIDs.contains(option.id)
				}
				
				item.options.append(
					OptionWrapper(
						id: option.id,
						title: option.title,
						price: option.price,
						isSelected: isSelected,
						item: option
					)
				)
			}
			self.modifiers.append(item)
		}
		
		// assign variables
		sectionsCount = self.modifiers.count + 2
		lastSection = sectionsCount - 1
		
		// prepare layout
		collectionViewLayout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
			switch section {
			case 0:
				return CollectionLayouts.fullWidth(height: 250)
			case self.lastSection:
				return CollectionLayouts.fullWidth(height: 300)
			default:
				return CollectionLayouts.productModifier()
			}
		}
		
		dataSource = self
		reloadData()
	}
}

extension ProductCollectionView: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int { sectionsCount }
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case lastSection:
			return 1
		default:
			return modifiers[section - 1].options.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch indexPath.section {
		case 0:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductHeaderCell.reuseIdentifier, for: indexPath) as? ProductHeaderCell else {
				fatalError("could not dequeue cell")
			}
			
			let selectedOptionsPrice = getSelectedOptions().reduce(0, { $0 + $1.price })
			let sumOfPrices = selectedOptionsPrice + (product?.price ?? 0)
			
			guard let product = product else {
				fatalError("product not defined")
			}
			
			cell.nameLabel.text = product.title
			cell.descriptionLabel.text = product.comments
			cell.priceLabel.text = sumOfPrices.currency
			cell.productImageView.setImage(product.image)
			
			let isFavorite = realmManager.get(Favorite.self, by: "id = \(product.id)").count > 0
			cell.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
			
			cell.favoriteButton.onTap { [weak self] in
				if isFavorite {
					self?.realmManager.deleteAll(of: Favorite.self, by: "id = \(product.id)")
				} else {
					let favorite = Favorite()
					favorite.id = product.id
					favorite.companyId = product.brandCode
					favorite.data = product.data
					self?.realmManager.set(favorite)
				}
				
				self?.reloadData()
			}
			
			return cell
			
		case lastSection:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductFooterCell.reuseIdentifier, for: indexPath) as? ProductFooterCell else {
				fatalError("could not dequeue cell")
			}
			
			cell.quantity = quantity
			
			cell.buyButton.onTap { [weak self] in
				
				if let producto = self?.updatingProduct {
					CartManager.shared.removeProduct(producto)
				}
				
				if let product = self?.product {
					CartManager.shared.addProduct(product,
												  with: self?.getSelectedOptions() ?? [],
												  and: cell.quantity,
												  notes: cell.observationTextView.text)
					
					self?.parentController?.toast("producto agregado al carrito")
				} else {
					fatalError("Error al agregar producto")
				}
			}
			
			return cell
			
		default:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.reuseIdentifier, for: indexPath) as? OptionCell else {
				fatalError("could not dequeue cell")
			}
			
			let sectionIndex = indexPath.section - 1
			
			let option = modifiers[sectionIndex].options[indexPath.row]
			cell.iconView.image = UIImage(named: option.isSelected ? "ic_checked_rounded" : "ic_unchecked_rounded")
			cell.titleLabel.text = option.summary

			cell.addTapGesture(handler: { _ in
				self.selectOption(at: sectionIndex, row: indexPath.row)
			})

			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		// swiftlint:disable all
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let headerView = collectionView.dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: ProductModifierHeader.reusableIdentifier,
					for: indexPath) as! ProductModifierHeader
			if indexPath.section > 0 && indexPath.section < lastSection {
				headerView.titleLabel.text = modifiers[indexPath.section - 1].title
			}
			return headerView
		default:
			return UICollectionReusableView()
		}
	}
	
}

extension ProductCollectionView {
	
	func selectOption(at section: Int, row: Int) {
		if modifiers[section].multiChoice {
			modifiers[section].options[row].isSelected.toggle()
		} else {
			let optionId = modifiers[section].options[row].id
			
			for index in 0...modifiers[section].options.count - 1 {
				if modifiers[section].options[index].id == optionId {
					modifiers[section].options[index].isSelected.toggle()
				} else {
					modifiers[section].options[index].isSelected = false
				}
			}
		}
		reloadData()
	}
	
	func getSelectedOptions() -> [ProductOption] {
		modifiers
			.flatMap({ $0.options })
			.filter({ $0.isSelected })
			.map({ $0.item })
	}
}
