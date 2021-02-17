//
//  NibLoadable.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit

protocol NibLoadable {
	static var reuseIdentifier: String { get }
	static var nib: UINib { get }
}

extension UITableView {
	func register(_ cell: NibLoadable.Type) {
		register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
	}
}

extension UICollectionView {
	func register(_ cell: NibLoadable.Type) {
		register(cell.nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
	}
}
