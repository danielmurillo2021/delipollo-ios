//
//  KeychainAccessibiltyItem.swift
//  themoviedb
//
//  Created by Daniel Murillo on 11/12/20.
//

import Foundation

// swiftlint:disable all

protocol KeychainAttrRepresentable {
	var keychainAttrValue: CFString { get }
}

public enum KeychainItemAccessibility {
	case afterFirstUnlock
	case afterFirstUnlockThisDeviceOnly
	case always
	case whenPasscodeSetThisDeviceOnly
	case alwaysThisDeviceOnly
	case whenUnlocked
	case whenUnlockedThisDeviceOnly
	
	static func accessibilityForAttributeValue(_ keychainAttrValue: CFString) -> KeychainItemAccessibility? {
		for (key, value) in keychainItemAccessibilityLookup {
			if value == keychainAttrValue {
				return key
			}
		}
		
		return nil
	}
}

private let keychainItemAccessibilityLookup: [KeychainItemAccessibility: CFString] = {
	var lookup: [KeychainItemAccessibility: CFString] = [
		.afterFirstUnlock: kSecAttrAccessibleAfterFirstUnlock,
		.afterFirstUnlockThisDeviceOnly: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
		.whenPasscodeSetThisDeviceOnly: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
		.whenUnlocked: kSecAttrAccessibleWhenUnlocked,
		.whenUnlockedThisDeviceOnly: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
	]

	return lookup
}()

extension KeychainItemAccessibility : KeychainAttrRepresentable {
	internal var keychainAttrValue: CFString {
		return keychainItemAccessibilityLookup[self]!
	}
}
