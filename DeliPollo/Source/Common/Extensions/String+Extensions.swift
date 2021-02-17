//
//  String+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 10/7/20.
//  Copyright © 2020 Daniel Murrillo. All rights reserved.
//

import UIKit
import Foundation

extension String {
	
	var boolValue: Bool {
		self.uppercased() == "S" || self == "1"
	}
	
	var doubleValue: Double {
		Double(self) ?? 0
	}
	
	var intValue: Int {
		Int(self.doubleValue)
	}
	
	var currency: String {
		self.doubleValue.currency
	}
	
	func getCardNumberFormatted() -> String {
		let trimmedString = self
			.padding(toLength: 16, withPad: "X", startingAt: 0)
			.components(separatedBy: .whitespaces).joined()
		let arrOfCharacters = Array(trimmedString)
		var modifiedCreditCardString = kEmptyString
		if arrOfCharacters.count > 0 {
			for index in 0...arrOfCharacters.count - 1 {
				modifiedCreditCardString.append(arrOfCharacters[index])
				if (index + 1) % 4 == 0 && index + 1 != arrOfCharacters.count {
					modifiedCreditCardString.append(" ")
				}
			}
		}
		return modifiedCreditCardString
	}
	
	func getCardDateFormatted() -> String {
		let trimmedString = self.components(separatedBy: .whitespaces).joined()
		let arrOfCharacters = Array(trimmedString)
		var modifiedCreditCardString = kEmptyString
		if arrOfCharacters.count > 0 {
			for index in 0...arrOfCharacters.count - 1 {
				modifiedCreditCardString.append(arrOfCharacters[index])
				if (index + 1) % 2 == 0 && index + 1 != arrOfCharacters.count {
					modifiedCreditCardString.append("/")
				}
			}
		}
		return modifiedCreditCardString
	}
	
	func getBankImage() -> UIImage? {
		let string = self.prefix(3).lowercased()
		switch string {
		case "bac", "laf", "ban", "fic":
			return UIImage(named: string)
		default:
			return nil
		}
	}
	
	func getCardTypeImage() -> UIImage? {
		if NSRegularExpression("^4[0-9 ]*").matches(self) {
			return UIImage(named: "card_visa")
		} else if NSRegularExpression("^3(4|7)[0-9 ]*").matches(self) {
			return UIImage(named: "card_amex")
		} else if NSRegularExpression("^5[0-9 ]*").matches(self) {
			return UIImage(named: "card_mastercard")
		} else if NSRegularExpression("^6[0-9 ]*").matches(self) {
			return UIImage(named: "card_discover")
		} else {
//			return UIImage(named: "ic_cards_rounded")
			return UIImage(named: "card_visa")
		}
	}
	
	func getCardType() -> String {
		if NSRegularExpression("^4[0-9 ]*").matches(self) {
			return "Visa"
		} else if NSRegularExpression("^3(4|7)[0-9 ]*").matches(self) {
			return "American Express"
		} else if NSRegularExpression("^5[0-9 ]*").matches(self) {
			return "Master Card"
		} else if NSRegularExpression("^6[0-9 ]*").matches(self) {
			return "Discover"
		} else {
			return kEmptyString
		}
	}
	
	func formatAsDate() -> String {
		// OJO: se deberia usar date formatter
		let array = self.split(separator: "-")
		if array.count == 3 {
			return array.reversed().joined(separator: "/")
		} else {
			return self
		}
	}
	
	func convertToImage() -> UIImage? {
		if let dataDecoded: Data = Data(base64Encoded: self, options: .init(rawValue: 0)) {
			return UIImage(data: dataDecoded)
		}
		#if DEBUG
		print("no pudo convertir la imagen")
		#endif
		return nil
	}
	
	static var appVersion: String {
		let dictionary = Bundle.main.infoDictionary!
		let version = dictionary["CFBundleShortVersionString"] as? String ?? kEmptyString
		let build = dictionary["CFBundleVersion"] as? String ?? kEmptyString
		return "\(version).\(build)"
	}
	
	// swiftlint:disable identifier_name
	static var OS: String {
		"iOS"
	}
}
