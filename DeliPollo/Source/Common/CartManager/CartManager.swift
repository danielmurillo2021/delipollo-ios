//
// PC GROUP SA
// DeliPollo - CartManager.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 10/1/21
// Copyright © 2021. All rights reserved.

import Foundation
import Combine

/// Representa grupo x marca en el carrito
struct CartGroup: Codable {
	var companyCode: String
	var brandCode: String
	var companyName: String
	var productos: [Producto]
}

/// Maneja carrito multimarcas
final class CartManager {
	
	static var shared = CartManager()
	
	private let repository: Repository = Repository()
	private let realmManager: RealmManager = RealmManager.shared
	private let cacheId: String = "com.pcgroup.delipollo.cart.manager"
	
	@Published var groups: [CartGroup] = [] {
		didSet {
			save()
			#if DEBUG
			print(groups.map({ $0.companyName }))
			print(groups.flatMap({ $0.productos.map({ ($0.resumen, $0.cantidad) }) }))
			#endif
		}
	}
	
	private init () {}
	
	func getSubtotal() -> Double {
		groups.flatMap({ $0.productos }).reduce(0, { $0 + $1.subTotal })
	}
	
	func getQuantity() -> Int {
		groups.flatMap({ $0.productos }).reduce(0, { $0 + $1.cantidad })
	}
	
	// MARK: Eliminar producto por indices
	
	func removeProduct(at groupIndex: Int, index: Int) {
		groups[groupIndex].productos.remove(at: index)
		if groups[groupIndex].productos.count == 0 {
			groups.remove(at: groupIndex)
		}
	}
	
	// MARK: Eliminar producto
	
	func removeProduct(_ product: Producto) {
		for index in 0...groups.count - 1 {
			groups[index].productos.removeAll(where: { $0.codProducto == product.codProducto && $0.resumen == product.resumen })
		}
	}
	
	// MARK: Eliminar grupo
	
	func removeGroup(_ brandCode: String) {
		groups.removeAll(where: { $0.brandCode == brandCode })
	}
	
	// MARK: Productos con opciones seleccionadas por el usuario
	
	func addProduct(_ product: Product, with options: [ProductOption], and quantity: Int, notes: String? = nil) {
		let brandName = Session.shared.getBrandName() ?? kEmptyString
		let summary = options
			.map({ $0.title.lowercased() })
			.sorted()
			.joined(separator: ", ")
		
		if let groupIndex = groups.firstIndex(where: { $0.brandCode == product.brandCode }) {
			if let productIndex = groups[groupIndex].productos.firstIndex(where: { $0.resumen == summary && $0.codProducto == product.code }),
			   areEqual(options: options, producto: groups[groupIndex].productos[productIndex]) {
				// actualiza cantidad si ya existe
				groups[groupIndex].productos[productIndex].cantidad = groups[groupIndex].productos[productIndex].cantidad + quantity
				groups[groupIndex].productos[productIndex].subTotal = Double(groups[groupIndex].productos[productIndex].cantidad) * groups[groupIndex].productos[productIndex].precio
			} else {
				// crea producto
				let newProduct = convertProduct(product, options: options, quantity: quantity, notes: notes)
				groups[groupIndex].productos.append(newProduct)
			}
		} else {
			// crear grupo y producto
			let newProduct = convertProduct(product, options: options, quantity: quantity, notes: notes)
			let newGroup = CartGroup(companyCode: product.companyCode, brandCode: product.brandCode, companyName: brandName, productos: [newProduct])
			groups.append(newGroup)
		}
	}
	
	// MARK: Productos con opciones por defecto
	
	func addProductWithDefaultOptions(_ product: Product, completion: @escaping (Result<Bool, APIError>) -> Void) {
		repository.getProduct(productId: product.code, companyId: product.companyCode, completion: { [weak self] result in
			switch result {
			case .success(let response):
				if let data = response.data {
					self?.addProduct(data)
				}
				completion(.success(true))
			case .failure(let error):
				completion(.failure(error))
			}
		})
	}
	
	private func addProduct(_ product: Product) {
		let brandName = Session.shared.getBrandName() ?? kEmptyString
		let summary = product.defaultOptions
			.map({ $0.title.lowercased() })
			.sorted()
			.joined(separator: ", ")
		
		if let groupIndex = groups.firstIndex(where: { $0.brandCode == product.brandCode }) {
			if let productIndex = groups[groupIndex].productos.firstIndex(where: { $0.resumen == summary && $0.codProducto == product.code }),
			   areEqual(product: product, producto: groups[groupIndex].productos[productIndex]) {
				let sumOfOptions = product.defaultOptions.reduce(0, { $0 + $1.price })
				groups[groupIndex].productos[productIndex].cantidad = groups[groupIndex].productos[productIndex].cantidad + 1
				groups[groupIndex].productos[productIndex].subTotal = Double(groups[groupIndex].productos[productIndex].cantidad) * (groups[groupIndex].productos[productIndex].precio + sumOfOptions)
			} else {
				groups[groupIndex].productos.append(convertProduct(product))
			}
		} else {
			let newGroup = CartGroup(companyCode: product.companyCode, brandCode: product.brandCode, companyName: brandName, productos: [convertProduct(product)])
			groups.append(newGroup)
		}
	}
	
	// MARK: Shared Methods
	
	// compara si opciones son iguales
	private func areEqual(options: [ProductOption], producto: Producto) -> Bool {
		let optionIDs = options.map({ $0.code })
		let opcionesIDs = producto.opciones.map({ $0.codOpcion })
		return optionIDs.count == opcionesIDs.count && optionIDs.sorted() == opcionesIDs.sorted()
	}
	
	// compara si opciones son iguales
	private func areEqual(product: Product, producto: Producto) -> Bool {
		let optionIDs = product.defaultOptions.map({ $0.code })
		let opcionesIDs = producto.opciones.map({ $0.codOpcion })
		return optionIDs.count == opcionesIDs.count && optionIDs.sorted() == opcionesIDs.sorted()
	}
	
	private func convertProduct(_ product: Product, options: [ProductOption]? = nil, quantity: Int? = nil, notes: String? = nil) -> Producto {
		let internalOptions = options ?? product.defaultOptions
		let sumOfOptions = internalOptions.reduce(0, { $0 + $1.price })
		let internalQuantity = Double(quantity ?? 1)
		return Producto(indiceFila: 0,
				porcentajeDescuento: 0,
				aplicaDescuento: product.applyDiscount,
				aplicaIva: product.taxable,
				cantidad: quantity ?? 1,
				codCategoria: product.categoryId,
				codProducto: product.code,
				codigoReferenciaProducto: product.referenceCode,
				descripcion: product.title,
				descuento: product.discountPercent,
				impuesto: 0,
				notas: notes ?? kEmptyString,
				opciones: convertOptions(internalOptions),
				precio: product.price,
				subTotal: internalQuantity * (product.price + sumOfOptions),
				totalLinea: internalQuantity * (product.price + sumOfOptions),
				descriptivos: kEmptyString,
				foto: product.image,
				codEmpresa: product.companyCode)
	}
	
	private func convertOptions(_ options: [ProductOption]) -> [Opcion] {
		options.map({ convertOption($0) })
	}
	
	private func convertOption(_ option: ProductOption) -> Opcion {
		Opcion(aplicaDescuento: option.applyDiscount,
			   aplicaIva: option.taxable,
			   codMenuRelacionado: option.relatedMenuCode,
			   codModificador: option.modifierCode,
			   codOpcion: option.code,
			   codTipoModificador: option.typeCode,
			   codigoReferencia: option.referenceCode,
			   descripcion: option.title,
			   id: option.id,
			   idCarritoItem: 0,
			   orden: 0,
			   precioOpcion: option.price)
	}
	
	// MARK: Cart Manager persitance
	
	func save() {
		let jsonObject = groups.map { $0.dictionary! }
		do {
			let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
			let cache = Cache()
			cache.id = cacheId
			cache.data = data
			#if DEBUG
			print("cart saved \(groups.count) groups")
			#endif
			realmManager.set(cache)
		} catch {
			print("Could not save cart groups: \(error)")
		}
	}
	
	func start() {
		groups = realmManager.getFromCache(cacheId, type: [CartGroup].self) ?? []
		#if DEBUG
		print("cart started with \(groups.count) groups")
		#endif
	}
}
