//
//  CreateAddressController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 30/12/20.
//

import UIKit

class CreateAddressController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "CreateAddressController"
	static var storyboardName: String = "Addresses"
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var summaryTextField: LoloTextField!
	@IBOutlet weak var cityTextField: LoloTextField!
	@IBOutlet weak var departmentTextField: LoloTextField!
	@IBOutlet weak var referenceTextField: LoloTextField!
	@IBOutlet weak var nameTextField: LoloTextField!
	@IBOutlet weak var isDefaultCheckBox: CheckBox!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	
	var latitude: Double?
	var longitude: Double?
	
	/// the selected address to be updated
	var selectedAddress: Address?
	
	/// indicates if user is updating address
	var isUpdating: Bool = false
	
	private let repository = Repository()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if isUpdating, let address = selectedAddress {
			nameTextField.text = address.name
			cityTextField.text = address.city
			departmentTextField.text = address.department
			referenceTextField.text = address.reference
			summaryTextField.text = address.summary
			isDefaultCheckBox.isSelected = address.isDefault == 1
		}
	}
	
	private func prepareUI() {
		
		titleLabel.text = isUpdating ? "editar dirección" : "dirección nueva"
		
		deleteButton.isHidden = !isUpdating
		
		saveButton.onTap {
			if self.isUpdating {
				self.update()
			} else {
				self.save()
			}
		}
		
		deleteButton.onTap {
			self.delete()
		}
		
		backButton.onTap {
			self.mainNavigationController.set(screen: self.isUpdating ? .addresses : .map)
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		cityTextField.isEnabled = false
		departmentTextField.isEnabled = false
		
		guard let latitude = latitude, let longitude = longitude else { return }
		
		LocationManager.shared.getLocationInformation(latitude: latitude, longitude: longitude, completion: { [weak self] data in
			if let data = data {
				self?.cityTextField.text = data.0
				self?.departmentTextField.text = data.1
			}
		})
	}
	
	private func delete() {
		guard let selectedAddress = selectedAddress else { return }
		
		showSpinner()
		repository.deleteAddress(id: selectedAddress.id, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if response.succeed {
					self?.mainNavigationController.alert(message: "¡listo!", icon: "ic_addresses", completion: {
						self?.mainNavigationController.set(screen: .addresses)
					})
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func update() {
		guard let selectedAddress = selectedAddress,
			  let summary = summaryTextField.text,
			  !summary.isEmpty,
			  let city = cityTextField.text,
			  !city.isEmpty,
			  let department = departmentTextField.text,
			  !department.isEmpty,
			  let reference = referenceTextField.text,
			  !reference.isEmpty,
			  let name = nameTextField.text,
			  !name.isEmpty else {
			alert(message: "Llene todos los campos")
			return
		}
		
		let data = UpdateAddressRequest(id: selectedAddress.id, name: name, summary: summary, reference: reference, isDefault: isDefaultCheckBox.isSelected ? 1 : 0)
		
		showSpinner()
		repository.updateAddress(data: data, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if response.succeed {
					self?.mainNavigationController.alert(message: "¡listo!", icon: "ic_addresses", completion: {
						self?.mainNavigationController.set(screen: .addresses)
					})
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func save() {
		
		guard let summary = summaryTextField.text,
			  !summary.isEmpty,
			  let city = cityTextField.text,
			  !city.isEmpty,
			  let department = departmentTextField.text,
			  !department.isEmpty,
			  let reference = referenceTextField.text,
			  !reference.isEmpty,
			  let name = nameTextField.text,
			  !name.isEmpty else {
			alert(message: "Llene todos los campos")
			return
		}
		
		let data = CreateAddressRequest(type: "HOME",
										name: name,
										summary: summary,
										department: department,
										city: city,
										reference: reference,
										latitude: latitude!.description,
										longitude: longitude!.description,
										gps: kEmptyString,
										kilometers: 1,
										phone: kEmptyString,
										isDefault: isDefaultCheckBox.isSelected ? 1 : 0)
		
		showSpinner()
		repository.createAddress(data: data, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if response.succeed {
					self?.mainNavigationController.alert(message: "¡listo!", icon: "ic_addresses", completion: {
						switch self?.mainNavigationController.context {
						case .checkout:
							self?.mainNavigationController.set(screen: .selectAddress)
						case .normal, .none:
							self?.mainNavigationController.set(screen: .addresses)
						}
					})
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
}
