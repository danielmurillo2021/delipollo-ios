//
// PC GROUP SA
// DeliPollo - CartTableView.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 12/1/21
// Copyright © 2021. All rights reserved.

import UIKit
import Combine

protocol CartTableViewDelegate: class {
	func didSelectCartProduct(_ product: Producto)
	func willProcessCartGroup(_ group: CartGroup)
	func didSetGroups(_ count: Int)
}

class CartTableView: UITableView {
	
	private var bindings = Set<AnyCancellable>()
	
	private var groups: [CartGroup] = [] {
		didSet {
			if let delegate = cartTableViewDelegate {
				delegate.didSetGroups(groups.count)
			}
		}
	}
	
	weak var cartTableViewDelegate: CartTableViewDelegate?
	
	func start() {
		backgroundColor = .clear
		separatorStyle = .none
		
		let headerNib = UINib(nibName: CartHeaderView.reuseIdentifier, bundle: nil)
		register(headerNib, forHeaderFooterViewReuseIdentifier: CartHeaderView.reuseIdentifier)
		
		let footerNib = UINib(nibName: CartFooterView.reuseIdentifier, bundle: nil)
		register(footerNib, forHeaderFooterViewReuseIdentifier: CartFooterView.reuseIdentifier)

		register(CartProductCell.self)
		dataSource = self
		delegate = self
		
		CartManager.shared.$groups
			.receive(on: RunLoop.main)
			.sink(receiveValue: { [weak self] value in
				self?.groups = value
				self?.reloadData()
			})
			.store(in: &bindings)
	}
}

extension CartTableView: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		groups.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		groups[section].productos.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CartProductCell.reuseIdentifier, for: indexPath) as? CartProductCell else {
			fatalError("could not find cell")
		}
		
		let producto = groups[indexPath.section].productos[indexPath.row]
		cell.productImageView.setImage(producto.foto ?? kEmptyString)
		cell.nameLabel.text = producto.descripcion
		cell.quantityLabel.text = producto.cantidad.description
		cell.subtotalLabel.text = producto.precio.currency
		cell.optionsLabel.text = producto.resumen
		
		cell.deleteButton.onTap {
			CartManager.shared.removeProduct(at: indexPath.section, index: indexPath.row)
		}
		
		cell.addTapGesture(handler: { [weak self] _ in
			if let delegate = self?.cartTableViewDelegate {
				delegate.didSelectCartProduct(producto)
			}
		})
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartHeaderView.reuseIdentifier) as? CartHeaderView else {
			fatalError("could not find header")
		}
		header.titleLabel.text = groups[section].companyName
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartFooterView.reuseIdentifier) as? CartFooterView else {
			fatalError("could not find footer")
		}
		
		let group = groups[section]
		let subtotal = group.productos.getSubtotal()
		footer.subtotalLabel.text = "Subtotal        \(PriceFormatter.shared.format(subtotal).currency)"
		
		footer.processButton.onTap { [weak self] in
			if let delegate = self?.cartTableViewDelegate {
				delegate.willProcessCartGroup(group)
			}
		}
		
		return footer
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 100 }
	
}

extension CartTableView: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }
}
