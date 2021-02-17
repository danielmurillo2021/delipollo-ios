//
//  Profile.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 24/12/20.
//

import Foundation

// swiftlint:disable all

struct UpdateProfile: Codable {
	var name: String
	var lastname: String
	var email: String
	var password: String
	var passwordConfirmation: String
	
	enum CodingKeys: String, CodingKey {
		case name = "Nombre"
		case lastname = "Apellido"
		case email = "Email"
		case password = "Password"
		case passwordConfirmation = "PasswordC"
	}
}

struct ProfileResponse: Codable {
	var id: Int
	var customerId: Int
	var name: String
	var lastname: String
	var email: String
	var phone: String
	var verified: String
	
	enum CodingKeys: String, CodingKey {
		case id = "CodUsuario"
		case customerId = "CodCliente"
		case name = "Nombre"
		case lastname = "Apellido"
		case email = "Email"
		case phone = "Telefono"
		case verified = "Verificado"
	}
}
