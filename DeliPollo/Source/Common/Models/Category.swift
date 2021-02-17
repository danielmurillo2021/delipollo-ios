//
//  Category.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 24/12/20.
//

import Foundation

// swiftlint:disable all
struct Category: Codable {
	var id: Int
	var code: String
	var brandId: String
	var title: String
	var color: String
	var reference: String
	var image: String
	var order: Int
	var active: String
	
	enum CodingKeys: String, CodingKey {
		case id = "IdCategoria"
		case code = "CodCategoria"
		case brandId = "CodMarca"
		case title = "Descripcion"
		case color = "Color"
		case reference = "CodigoReferencia"
		case image = "UrlImg"
		case order = "Orden"
		case active = "Activo"
	}
}
