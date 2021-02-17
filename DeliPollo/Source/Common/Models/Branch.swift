//
// PC GROUP SA
// DeliPollo - Branch.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 10/1/21
// Copyright © 2021. All rights reserved.

import Foundation

// swiftlint:disable all
struct Branch: Codable {
	let id: Int
	let companyCode, code, name, departament: String
	let latitude, longitude: String
	let coverage: Int
	let validateOpeningHour, openingHour, validateClosingHour, closingHour: String
	let validateAttentionDays, attentionDays, slogan: String

	enum CodingKeys: String, CodingKey {
		case id = "IdSucursal"
		case companyCode = "CodEmpresa"
		case code = "CodSucursal"
		case name = "Nombre"
		case departament = "Departamento"
		case latitude = "Latitud"
		case longitude = "Longitud"
		case coverage = "CoberturaKm"
		case validateOpeningHour = "ValidaHoraApertura"
		case openingHour = "HoraApertura"
		case validateClosingHour = "ValidaHoraCierre"
		case closingHour = "HoraCierre"
		case validateAttentionDays = "ValidaDiasAtencion"
		case attentionDays = "DiasAtencion"
		case slogan = "Eslogan"
	}
}

struct BranchCoverage: Codable {
	let idSucursal: Int
	let codEmpresa, codSucursal, nombre, departamento: String
	let latitud, longitud: String
	let coberturaKM: Int
	let validaHoraApertura, horaApertura, validaHoraCierre, horaCierre: String
	let validaDiasAtencion, diasAtencion, eslogan: String

	enum CodingKeys: String, CodingKey {
		case idSucursal = "IdSucursal"
		case codEmpresa = "CodEmpresa"
		case codSucursal = "CodSucursal"
		case nombre = "Nombre"
		case departamento = "Departamento"
		case latitud = "Latitud"
		case longitud = "Longitud"
		case coberturaKM = "CoberturaKm"
		case validaHoraApertura = "ValidaHoraApertura"
		case horaApertura = "HoraApertura"
		case validaHoraCierre = "ValidaHoraCierre"
		case horaCierre = "HoraCierre"
		case validaDiasAtencion = "ValidaDiasAtencion"
		case diasAtencion = "DiasAtencion"
		case eslogan = "Eslogan"
	}
}
