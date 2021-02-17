//
//  Card.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 24/12/20.
//

import Foundation

// swiftlint:disable all

struct Card: Codable {
	var id: Int
	var name: String
	var number: String
	var expiration: String
	var cvv: String
	var isDefault: Int
	var bank: String
	
	enum CodingKeys: String, CodingKey {
		case id = "CodTarjeta"
		case name = "Nombre"
		case number = "Numero"
		case expiration = "FechaExpira"
		case cvv = "Cvv"
		case isDefault = "Predeterminada"
		case bank = "TipoBanco"
	}
}

struct CreateCardRequest: Codable {
	var name: String
	var number: String
	var expiration: String
	var cvv: String
	var isDefault: Int
	
	enum CodingKeys: String, CodingKey {
		case name = "Nombre"
		case number = "Numero"
		case expiration = "FechaExpira"
		case cvv = "Cvv"
		case isDefault = "Predeterminada"
	}
}
