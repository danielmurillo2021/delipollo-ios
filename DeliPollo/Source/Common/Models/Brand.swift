//
//  Brand.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import Foundation

// swiftlint:disable all
struct Brand: Codable {
	var id: Int
	var code: String
	var name: String
	var commercialName: String
	var logo: String
	var banner: String
	var slogan: String
	var mission: String
	var vision: String
	var erp: String
	
	enum CodingKeys: String, CodingKey {
		case id = "IdMarca"
		case code = "CodMarca"
		case name = "Nombre"
		case commercialName = "NombreComercial"
		case logo = "UrlLogo"
		case banner = "UrlBanner"
		case slogan = "Eslogan"
		case mission = "Mision"
		case vision = "Vision"
		case erp = "AplicaErp"
	}
}
