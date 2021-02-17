//
//  Double+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 10/31/20.
//  Copyright © 2020 Daniel Murrillo. All rights reserved.
//

import Foundation

extension Formatter {
	static let number = NumberFormatter()
}

extension Locale {
	static let esNICA: Locale = .init(identifier: "es_NI")
}

extension Numeric {
	func formatted(style: NumberFormatter.Style, locale: Locale = .current, with groupingSeparator: String? = nil) -> String {
		Formatter.number.locale = locale
		Formatter.number.numberStyle = style
		Formatter.number.roundingMode = .halfDown
		if let groupingSeparator = groupingSeparator {
			Formatter.number.groupingSeparator = groupingSeparator
		}
		return Formatter.number.string(for: self) ?? ""
	}
	
	var currencyNI: String { formatted(style: .currency, locale: .esNICA) }
}

extension Double {
	
	var currency: String {
		let value = PriceFormatter.shared.format(self)
		return value.currencyNI
	}
	
	var intValue: Int {
		Int(self)
	}
	
	var suggestedCash: Double {
		let mod = Int(self) % 100
		let value = Int(self) - (mod)
		return Double(mod == 0 ? value : value + 100)
	}
}

extension Int {
	
	var doubleValue: Double {
		Double(self)
	}
	
	var boolValue: Bool {
		self == 1
	}
}

struct PriceFormatter {
	
	static var shared = PriceFormatter()
	
	private var priceFormatter: NumberFormatter = {
		let decimalFormatter = NumberFormatter()
		decimalFormatter.minimumFractionDigits = 2
		decimalFormatter.maximumFractionDigits = 2
		decimalFormatter.roundingMode = .halfUp
		return decimalFormatter
	}()
	
	func format(_ value: Double) -> Double {
		return priceFormatter.string(from: NSNumber(value: value))?.doubleValue ?? 0
	}
}
