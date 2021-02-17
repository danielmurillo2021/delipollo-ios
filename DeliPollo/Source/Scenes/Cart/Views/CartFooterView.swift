//
// PC GROUP SA
// DeliPollo - CartFooterView.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 12/1/21
// Copyright © 2021. All rights reserved.

import UIKit

class CartFooterView: UITableViewHeaderFooterView {
	
	static let reuseIdentifier: String = "CartFooterView"
	
	@IBOutlet weak var subtotalLabel: UILabel!
	@IBOutlet weak var processButton: UIButton!
}
