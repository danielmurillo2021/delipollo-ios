//
// PC GROUP SA
// DeliPollo - Favorite.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 14/1/21
// Copyright © 2021. All rights reserved.

import Foundation
import RealmSwift

// swiftlint:disable all
class Favorite: Object {
	@objc dynamic var id: Int = 0
	@objc dynamic var companyId: String = kEmptyString
	@objc dynamic var data: Data? = nil
	@objc dynamic var createdAt: Date = Date()
	
	override class func primaryKey() -> String? { "id" }
}
