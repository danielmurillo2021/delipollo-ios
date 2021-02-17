//
//  Promotion.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 2/1/21.
//

import Foundation

// swiftlint:disable all

struct Promotion: Codable {
	var id: Int
	var type: String?
	var image: String
	var promoType: Value
	var code: Value
	
	enum CodingKeys: String, CodingKey {
		case id = "CodImagenPromocion"
		case type = "Tipo"
		case image = "Img_Path"
		case promoType
		case code = "promoCode"
	}
}

