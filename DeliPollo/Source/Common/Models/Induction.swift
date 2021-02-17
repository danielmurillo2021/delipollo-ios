//
//  Induction.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 24/12/20.
//

import Foundation

// swiftlint:disable all
struct Induction: Codable {
	var id: Int
	var title: String
	var subtitle: String
	var image: String
	var order: Int
	
	enum CodingKeys: String, CodingKey {
		case id = "IdInduccion"
		case title = "Titulo"
		case subtitle = "Descripcion"
		case image = "UrlImg"
		case order = "Orden"
	}
}
