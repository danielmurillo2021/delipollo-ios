//
//  Value.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 26/12/20.
//

import Foundation

/// Used for multi-type values coming from API  (-.-')
enum Value: Codable {
	case string(String)
	case int(Int)
	case double(Double)
	case null
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let value = try? container.decode(String.self) {
			self = .string(value)
			return
		}
		if let value = try? container.decode(Int.self) {
			self = .int(value)
			return
		}
		if let value = try? container.decode(Double.self) {
			self = .double(value)
			return
		} else {
			self = .null
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
		case .string(let value):
			try container.encode(value)
		case .int(let value):
			try container.encode(value)
		case .double(let value):
			try container.encode(value)
		default:
			try container.encode(kEmptyString)
		}
	}
}

extension Value {
	
	var stringValue: String {
		switch self {
		case .string(let value):
			return value
		case .int(let value):
			return value.description
		case .double(let value):
			return value.description
		default:
			return kEmptyString
		}
	}
	
	var intValue: Int {
		switch self {
		case .int(let value):
			return value
		default:
			return 0
		}
	}
}
