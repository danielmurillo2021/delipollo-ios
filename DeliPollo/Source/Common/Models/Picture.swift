//
// PC GROUP SA
// DeliPollo - Picture.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 15/1/21
// Copyright © 2021. All rights reserved.

import Foundation

struct Picture: Codable {
	var file: String
	
	enum CodingKeys: String, CodingKey {
		case file = "FotoUsuario"
	}
}
