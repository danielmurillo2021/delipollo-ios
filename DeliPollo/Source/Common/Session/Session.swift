//
//  Session.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 24/12/20.
//

import Foundation

struct Session {
	
	static let shared = Session()
	
	private let keychain = KeychainWrapper.standard
	
	private let kDefaultBrandCode: String = "com.pcgroup.delipollo.session.brand.code"
	private let kDefaultBrandName: String = "com.pcgroup.delipollo.session.brand.name"
	private let kDefaultBrandLogo: String = "com.pcgroup.delipollo.session.brand.logo"
	private let kUserToken: String = "com.pcgroup.delipollo.session.user.token"
	private let kUserEmail: String = "com.pcgroup.delipollo.session.user.email"
	private let kRegistrationToken: String = "com.pcgroup.delipollo.session.registration.token"
	private let kUserName: String = "com.pcgroup.delipollo.session.user.name"
	private let kUserLastname: String = "com.pcgroup.delipollo.session.user.lastname"
	private let kUserPhone: String = "com.pcgroup.delipollo.session.user.phone"
	
	private init() {}
	
	/// sets default brand
	func setBrand(_ brand: Brand) {
		keychain.set(brand.code, forKey: kDefaultBrandCode)
		keychain.set(brand.name, forKey: kDefaultBrandName)
		keychain.set(brand.logo, forKey: kDefaultBrandLogo)
	}
	
	/// get default brand code
	func getBrandCode() -> String? {
		keychain.string(forKey: kDefaultBrandCode)
	}
	
	func getBrandName() -> String? {
		keychain.string(forKey: kDefaultBrandName)
	}
	
	func getBrandLogo() -> String? {
		keychain.string(forKey: kDefaultBrandLogo)
	}
	
	/// store the user token after login
	func setUserToken(_ token: String) {
		keychain.set(token, forKey: kUserToken)
//		keychain.removeObject(forKey: kRegistrationToken)
	}
	
	/// store the user email
	func setUserEmail(_ email: String) {
		keychain.set(email, forKey: kUserEmail)
	}
	
	func setUserPhone(_ phone: String) {
		keychain.set(phone, forKey: kUserPhone)
	}
	
	/// store the registration token after signin
	func setRegistrationToken(_ token: String) {
		keychain.set(token, forKey: kRegistrationToken)
	}
	
	/// set user´s info
	func setUser(name: String, lastname: String, email: String) {
		keychain.set(name, forKey: kUserName)
		keychain.set(lastname, forKey: kUserLastname)
		keychain.set(email, forKey: kUserEmail)
	}
	
	func userIsAuthenticated() -> Bool {
		keychain.string(forKey: kUserToken) != nil
	}
	
	func getUserToken() -> String? {
		keychain.string(forKey: kUserToken)
	}
	
	func getUserEmail() -> String? {
		keychain.string(forKey: kUserEmail)
	}
	
	func getUserPhone() -> String? {
		keychain.string(forKey: kUserPhone)
	}
	
	func getRegistrationToken() -> String? {
		keychain.string(forKey: kRegistrationToken)
	}
	
	func getUserName() -> String? {
		keychain.string(forKey: kUserName)
	}
	
	func getUserFullname() -> String? {
		if let name = keychain.string(forKey: kUserName),
		   let lastname = keychain.string(forKey: kUserLastname) {
			return "\(name) \(lastname)"
		}
		return nil
	}
	
	func clear() {
//		keychain.removeAllKeys()
		keychain.removeObject(forKey: kUserName)
		keychain.removeObject(forKey: kUserEmail)
//		keychain.removeObject(forKey: kUserPhone)
		keychain.removeObject(forKey: kUserLastname)
		keychain.removeObject(forKey: kUserToken)
		keychain.removeObject(forKey: kRegistrationToken)
		RealmManager.shared.deleteAll(of: Cache.self, by: "id != 'com.pcgroup.delipollo.cart.manager'")
	}
}
