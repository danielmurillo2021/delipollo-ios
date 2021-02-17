//
//  HTTPResponse.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import Foundation

struct HTTPResponse<T: Codable>: Codable {
	var succeed: Bool
	var message: String
	var data: T?
	
	enum CodingKeys: String, CodingKey {
		case succeed = "resp"
		case message = "mensaje"
		case data = "datos"
	}
}

enum APIError: Error {
	case unknown(String)
	case serialization
	case forbidden
	case notFound
	case internetConnection
}

enum ContentType: String {
	case json = "application/json"
	case urlEncoded = "application/x-www-form-urlencoded"
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}
