//
//  Cache.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import RealmSwift

// swiftlint:disable all
class Cache: Object {
	@objc dynamic var id: String = kEmptyString
	@objc dynamic var data: Data? = nil
	@objc dynamic var createdAt: Date = Date()
	@objc dynamic var updatedAt: Date = Date()
	
	override class func primaryKey() -> String? {
		"id"
	}
}
