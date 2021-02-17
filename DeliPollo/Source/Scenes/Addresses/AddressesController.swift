//
//  AddressesController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit

class AddressesController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "AddressesController"
	static var storyboardName: String = "Addresses"
	
	private let repository: Repository = Repository()
	
	private(set) var addresses: [Address] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
				self.heightConstraint.constant = CGFloat(self.addresses.count * 100)
				self.separatorView.isHidden = self.addresses.isEmpty
				self.topConstraint.constant = self.addresses.isEmpty ? 140 : 24
				self.addLabel.isHidden = !self.addresses.isEmpty
			}
		}
	}
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var createButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	@IBOutlet weak var addLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadData()
	}
	
	private func prepareUI() {
		tableView.separatorStyle = .none
		tableView.register(AddressCell.self)
		tableView.dataSource = self
		tableView.delegate = self
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		createButton.onTap {
			self.mainNavigationController.set(screen: .map)
		}
	}
	
	private func loadData() {
		repository.getAddresses(cache: { [weak self] response in
			if let data = response.data {
				self?.addresses = data.sorted(by: { $0.isDefault > $1.isDefault })
			}
		}, completion: { [weak self] result in
			switch result {
			case .success(let response):
				if let data = response.data {
					self?.addresses = data.sorted(by: { $0.isDefault > $1.isDefault })
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
}

extension AddressesController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		addresses.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.reuseIdentifier, for: indexPath) as? AddressCell ?? AddressCell()
		
		let address = self.addresses[indexPath.row]
		cell.titleLabel.text = address.name
		cell.subtitleLabel.text = address.summary
		cell.starView.isHidden = address.isDefault == 0
		
		cell.addTapGesture(handler: { _ in
			self.mainNavigationController.set(screen: .updateAddress(address))
		})
		
		return cell
	}
	
}

extension AddressesController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		100
	}
}
