//
//  LoginResponse.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 24/12/20.
//

import Foundation

struct TokenResponse: Codable {
	var token: String
	
	enum CodingKeys: String, CodingKey {
		case token = "Token"
	}
}
