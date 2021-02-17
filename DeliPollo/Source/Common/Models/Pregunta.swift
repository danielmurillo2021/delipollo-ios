//
// PC GROUP SA
// DeliPollo - Pregunta.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 12/1/21
// Copyright © 2021. All rights reserved.

import Foundation

struct Pregunta: Codable {
	let codPregunta: Int
	let codMarca, pregunta: String
	let orden: Int

	enum CodingKeys: String, CodingKey {
		case codPregunta = "CodPregunta"
		case codMarca = "CodMarca"
		case pregunta = "Pregunta"
		case orden = "Orden"
	}
}
