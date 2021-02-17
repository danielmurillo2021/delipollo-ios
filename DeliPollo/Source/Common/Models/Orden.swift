//
// PC GROUP SA
// DeliPollo - Orden.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 12/1/21
// Copyright © 2021. All rights reserved.

import Foundation

// swiftlint:disable all

// Se dejo el modelo en español porque ya no importan las guias de estilo

struct Orden: Codable {
	let codOrden: Int
	let codMarca, numeroSeguimiento, fechaOrden, horaOrden: String
	let total, subTotal, impuesto, transporte: String
	let codEstado: Int
	let decripcionEstado, direccion, tieneCupon, numeroCupon: String
	let montoCupon, estaValorada, tran: String

	enum CodingKeys: String, CodingKey {
		case codOrden = "CodOrden"
		case codMarca = "CodMarca"
		case numeroSeguimiento = "NumeroSeguimiento"
		case fechaOrden = "FechaOrden"
		case horaOrden = "HoraOrden"
		case total = "Total"
		case subTotal = "SubTotal"
		case impuesto = "Impuesto"
		case transporte = "Transporte"
		case codEstado = "CodEstado"
		case decripcionEstado = "DecripcionEstado"
		case direccion = "Direccion"
		case tieneCupon = "TieneCupon"
		case numeroCupon = "NumeroCupon"
		case montoCupon = "MontoCupon"
		case estaValorada = "EstaValorada"
		case tran = "Tran"
	}
}
