//
//  Address.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 24/12/20.
//

import Foundation

// swiftlint:disable all

/// Represents type 'direcciones' from API
struct Address: Codable {
	var id: Int
	var type: String
	var name: String
	var summary: String
	var department: String
	var city: String
	var reference: String
	var latitude: String
	var longitude: String
	var gps: String
	var kilometers: Double
	var fee: Double
	var isDefault: Int
	
	enum CodingKeys: String, CodingKey {
		case id = "CodDireccion"
		case type = "TipoDireccion"
		case name = "Nombre"
		case summary = "Direccion"
		case department = "Departamento"
		case city = "Ciudad"
		case reference = "Referencia"
		case latitude = "Latitud"
		case longitude = "Longitud"
		case gps = "DireccionGps"
		case kilometers = "Kilometros"
		case fee = "ValorTransporte"
		case isDefault = "Predeterminada"
	}
}

/// Represents the body for creating an address
struct CreateAddressRequest: Codable {
	var type: String
	var name: String
	var summary: String
	var department: String
	var city: String
	var reference: String
	var latitude: String
	var longitude: String
	var gps: String
	var kilometers: Double
	var phone: String
	var isDefault: Int
	
	enum CodingKeys: String, CodingKey {
		case type = "TipoDireccion"
		case name = "Nombre"
		case summary = "Direccion"
		case department = "Departamento"
		case city = "Ciudad"
		case reference = "Referencia"
		case latitude = "Latitud"
		case longitude = "Longitud"
		case gps = "DireccionGps"
		case kilometers = "Kilometros"
		case phone = "Telefono"
		case isDefault = "Predeterminada"
	}
}

/// Represents the body for updating an address
struct UpdateAddressRequest: Codable {
	var id: Int
	var name: String
	var summary: String
	var reference: String
	var isDefault: Int
	
	enum CodingKeys: String, CodingKey {
		case id = "CodDireccion"
		case name = "Nombre"
		case summary = "Direccion"
		case reference = "Referencia"
		case isDefault = "Predeterminada"
	}
}
