//
//  KeychainWrapper.swift
//  themoviedb
//
//  Created by Daniel Murillo on 11/12/20.
//

import Foundation

// swiftlint:disable all

private let SecMatchLimit: String! = kSecMatchLimit as String
private let SecReturnData: String! = kSecReturnData as String
private let SecReturnPersistentRef: String! = kSecReturnPersistentRef as String
private let SecValueData: String! = kSecValueData as String
private let SecAttrAccessible: String! = kSecAttrAccessible as String
private let SecClass: String! = kSecClass as String
private let SecAttrService: String! = kSecAttrService as String
private let SecAttrGeneric: String! = kSecAttrGeneric as String
private let SecAttrAccount: String! = kSecAttrAccount as String
private let SecAttrAccessGroup: String! = kSecAttrAccessGroup as String
private let SecReturnAttributes: String = kSecReturnAttributes as String

open class KeychainWrapper {
	
	public static let standard = KeychainWrapper()
	
	private (set) public var serviceName: String
	
	private (set) public var accessGroup: String?
	
	private static let defaultServiceName: String = {
		return Bundle.main.bundleIdentifier ?? "SwiftKeychainWrapper"
	}()

	private convenience init() {
		self.init(serviceName: KeychainWrapper.defaultServiceName)
	}

	public init(serviceName: String, accessGroup: String? = nil) {
		self.serviceName = serviceName
		self.accessGroup = accessGroup
	}

	open func hasValue(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		if let _ = data(forKey: key, withAccessibility: accessibility) {
			return true
		} else {
			return false
		}
	}
	
	open func accessibilityOfKey(_ key: String) -> KeychainItemAccessibility? {
		var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key)
		keychainQueryDictionary.removeValue(forKey: SecAttrAccessible)
		keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
		keychainQueryDictionary[SecReturnAttributes] = kCFBooleanTrue

		var result: AnyObject?
		let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)

		guard status == noErr, let resultsDictionary = result as? [String:AnyObject], let accessibilityAttrValue = resultsDictionary[SecAttrAccessible] as? String else {
			return nil
		}
	
		return KeychainItemAccessibility.accessibilityForAttributeValue(accessibilityAttrValue as CFString)
	}

	open func allKeys() -> Set<String> {
		var keychainQueryDictionary: [String:Any] = [
			SecClass: kSecClassGenericPassword,
			SecAttrService: serviceName,
			SecReturnAttributes: kCFBooleanTrue!,
			SecMatchLimit: kSecMatchLimitAll,
		]

		if let accessGroup = self.accessGroup {
			keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
		}

		var result: AnyObject?
		let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)

		guard status == errSecSuccess else { return [] }

		var keys = Set<String>()
		if let results = result as? [[AnyHashable: Any]] {
			for attributes in results {
				if let accountData = attributes[SecAttrAccount] as? Data,
					let account = String(data: accountData, encoding: String.Encoding.utf8) {
					keys.insert(account)
				}
			}
		}
		return keys
	}
	
	open func integer(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Int? {
		guard let numberValue = object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
			return nil
		}
		
		return numberValue.intValue
	}
	
	open func float(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Float? {
		guard let numberValue = object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
			return nil
		}
		
		return numberValue.floatValue
	}
	
	open func double(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Double? {
		guard let numberValue = object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
			return nil
		}
		
		return numberValue.doubleValue
	}
	
	open func bool(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool? {
		guard let numberValue = object(forKey: key, withAccessibility: accessibility) as? NSNumber else {
			return nil
		}
		
		return numberValue.boolValue
	}
	
	open func string(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> String? {
		guard let keychainData = data(forKey: key, withAccessibility: accessibility) else {
			return nil
		}
		
		return String(data: keychainData, encoding: String.Encoding.utf8) as String?
	}
	
	open func object(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> NSCoding? {
		guard let keychainData = data(forKey: key, withAccessibility: accessibility) else {
			return nil
		}
		
		return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keychainData) as? NSCoding
	}

	
	open func data(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Data? {
		var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)
		keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
		keychainQueryDictionary[SecReturnData] = kCFBooleanTrue
		var result: AnyObject?
		let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)
		return status == noErr ? result as? Data : nil
	}
	
	open func dataRef(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Data? {
		var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)
		keychainQueryDictionary[SecMatchLimit] = kSecMatchLimitOne
		keychainQueryDictionary[SecReturnPersistentRef] = kCFBooleanTrue
		var result: AnyObject?
		let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)
		return status == noErr ? result as? Data : nil
	}
	
	@discardableResult open func set(_ value: Int, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
	}
	
	@discardableResult open func set(_ value: Float, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
	}
	
	@discardableResult open func set(_ value: Double, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
	}
	
	@discardableResult open func set(_ value: Bool, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		return set(NSNumber(value: value), forKey: key, withAccessibility: accessibility)
	}

	@discardableResult open func set(_ value: String, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		if let data = value.data(using: .utf8) {
			return set(data, forKey: key, withAccessibility: accessibility)
		} else {
			return false
		}
	}

	@discardableResult open func set(_ value: NSCoding, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		let data = try! NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
		
		return set(data, forKey: key, withAccessibility: accessibility)
	}

	@discardableResult open func set(_ value: Data, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		var keychainQueryDictionary: [String:Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)
		keychainQueryDictionary[SecValueData] = value
		
		if let accessibility = accessibility {
			keychainQueryDictionary[SecAttrAccessible] = accessibility.keychainAttrValue
		} else {
			keychainQueryDictionary[SecAttrAccessible] = KeychainItemAccessibility.whenUnlocked.keychainAttrValue
		}
		
		let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)
		
		if status == errSecSuccess {
			return true
		} else if status == errSecDuplicateItem {
			return update(value, forKey: key, withAccessibility: accessibility)
		} else {
			return false
		}
	}

	@available(*, deprecated, message: "remove is deprecated, use removeObject instead")
	@discardableResult open func remove(key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		return removeObject(forKey: key, withAccessibility: accessibility)
	}
	
	@discardableResult open func removeObject(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		let keychainQueryDictionary: [String:Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)

		// Delete
		let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)

		if status == errSecSuccess {
			return true
		} else {
			return false
		}
	}

	@discardableResult open func removeAllKeys() -> Bool {
		var keychainQueryDictionary: [String:Any] = [SecClass:kSecClassGenericPassword]
		keychainQueryDictionary[SecAttrService] = serviceName
		
		if let accessGroup = self.accessGroup {
			keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
		}
		
		let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)
		
		if status == errSecSuccess {
			return true
		} else {
			return false
		}
	}
	
	open class func wipeKeychain() {
		deleteKeychainSecClass(kSecClassGenericPassword) // Generic password items
		deleteKeychainSecClass(kSecClassInternetPassword) // Internet password items
		deleteKeychainSecClass(kSecClassCertificate) // Certificate items
		deleteKeychainSecClass(kSecClassKey) // Cryptographic key items
		deleteKeychainSecClass(kSecClassIdentity) // Identity items
	}

	@discardableResult private class func deleteKeychainSecClass(_ secClass: AnyObject) -> Bool {
		let query = [SecClass: secClass]
		let status: OSStatus = SecItemDelete(query as CFDictionary)
		
		if status == errSecSuccess {
			return true
		} else {
			return false
		}
	}
	
	private func update(_ value: Data, forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
		var keychainQueryDictionary: [String:Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)
		let updateDictionary = [SecValueData:value]
		
		if let accessibility = accessibility {
			keychainQueryDictionary[SecAttrAccessible] = accessibility.keychainAttrValue
		}
		
		let status: OSStatus = SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)

		if status == errSecSuccess {
			return true
		} else {
			return false
		}
	}

	private func setupKeychainQueryDictionary(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> [String:Any] {
		
		var keychainQueryDictionary: [String:Any] = [SecClass:kSecClassGenericPassword]
		keychainQueryDictionary[SecAttrService] = serviceName
		
		if let accessibility = accessibility {
			keychainQueryDictionary[SecAttrAccessible] = accessibility.keychainAttrValue
		}
		
		if let accessGroup = self.accessGroup {
			keychainQueryDictionary[SecAttrAccessGroup] = accessGroup
		}
		
		let encodedIdentifier: Data? = key.data(using: String.Encoding.utf8)
		keychainQueryDictionary[SecAttrGeneric] = encodedIdentifier
		keychainQueryDictionary[SecAttrAccount] = encodedIdentifier
		return keychainQueryDictionary
	}
}
