//
//  Product.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 26/12/20.
//

import Foundation

// swiftlint:disable all

struct Product: Codable {
	var id: Int
	var code: String
	var companyCode: String
	var brandCode: String
	var categoryId: String
	var title: String
	var subtitle: String
	var comments: String
	var initialPrice: Double
	var taxable: String
	var applyDiscount: String
	var discountPercent: Double
	var image: String
	var secondImage: String
	var thirdImage: String
	var color: String
	var viewText: String
	var isCombo: Int
	var isOption: Int
	var isPromo: Int
	var isPopular: Int
	var applyApp: String // wtf
	var referenceCode: String
	var order: Int
	var modifiers: [ProductModifier]?
	
	var price: Double {
		taxable.boolValue
			? PriceFormatter.shared.format(initialPrice) * 1.15
			:  PriceFormatter.shared.format(initialPrice)
	}
	
	var defaultOptions: [ProductOption] {
		modifiers?.flatMap({ modifier in
			modifier.options?.filter({ option in
				option.code == modifier.defaultOptionCode
			}) ?? []
		}) ?? []
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "IdProducto"
		case code = "CodProducto"
		case companyCode = "CodEmpresa"
		case brandCode = "CodMarca"
		case categoryId = "CodCategoria"
		case title = "Descripcion"
		case subtitle = "Descripcion2"
		case comments = "Observaciones"
		case initialPrice = "Precio"
		case taxable = "AplicaIva"
		case applyDiscount = "AplicaDescuento"
		case discountPercent = "PorcentajeDescuento"
		case image = "UrlImg"
		case secondImage = "UrlImg2"
		case thirdImage = "UrlImg3"
		case color = "Color"
		case viewText = "VerTexto"
		case isCombo = "EsCombo"
		case isOption = "EsSoloOpcion"
		case isPromo = "EsPromocion"
		case isPopular = "EsPopular"
		case applyApp = "AplicaApp"
		case referenceCode = "CodigoReferencia"
		case order = "Orden"
		case modifiers = "Modificadores"
	}
}

struct ProductModifier: Codable {
	var id: Int
	var code: String
	var productCode: String
	var brandCode: String
	var categoryCode: String
	var title: String
	var typeCode: String
	var isRequired: String
	var multipleSelection: String
	var maxSelection: Int
	var referenceCode: String
	var order: Int
	var applyDefaultOption: String
	var defaultOptionCode: String
	var options: [ProductOption]?
	
	enum CodingKeys: String, CodingKey {
		case id = "IdModificador"
		case code = "CodModificador"
		case productCode = "CodProducto"
		case brandCode = "CodMarca"
		case categoryCode = "CodCategoria"
		case title = "Descripcion"
		case typeCode = "CodTipoModificador"
		case isRequired = "EsRequerido"
		case multipleSelection = "EsMultipleSeleccion"
		case maxSelection = "SeleccionMaxima"
		case referenceCode = "CodigoReferencia"
		case order = "Orden"
		case applyDefaultOption = "AplicaOpcionPorDefecto"
		case defaultOptionCode = "CodOpcionDefecto"
		case options = "Opciones"
	}
}

struct ProductOption: Codable {
	var id: Int
	var code: String
	var modifierCode: String
	var productCode: String
	var brandCode: String
	var categoryCode: String
	var title: String
	var typeCode: String
	var relatedMenuCode: String
	var initialPrice: Double
	var taxable: String
	var applyDiscount: String
	var referenceCode: String
	var order: Int
	
	var price: Double {
		PriceFormatter.shared.format(taxable.boolValue ? initialPrice * 1.15 : initialPrice)
	}
	
	enum CodingKeys: String, CodingKey {
		case id = "IdOpcion"
		case code = "CodOpcion"
		case modifierCode = "CodModificador"
		case productCode = "CodProducto"
		case brandCode = "CodMarca"
		case categoryCode = "CodCategoria"
		case title = "Descripcion"
		case typeCode = "CodTipoModificador"
		case relatedMenuCode = "CodMenuRelacionado"
		case initialPrice = "PrecioOpcion"
		case taxable = "AplicaIva"
		case applyDiscount = "AplicaDescuento"
		case referenceCode = "CodigoReferencia"
		case order = "Orden"
	}
}

// MARK: - Wrappers

struct OptionWrapper {
	var id: Int
	var title: String
	var price: Double
	var isSelected: Bool = false
	var item: ProductOption // se agrega para tener referencia de la info de la opcion
	var summary: String {
		price > 0 ? "\(title) [+C$\(price.description)]" : title
	}
}

struct ModifierWrapper {
	var id: Int
	var title: String
	var options: [OptionWrapper]
	var multiChoice: Bool
	var rows: Int {
		options.count + 1
	}
}
