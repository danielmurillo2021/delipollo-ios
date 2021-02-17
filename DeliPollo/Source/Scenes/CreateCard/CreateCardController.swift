//
//  CreateCardController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 29/12/20.
//

import UIKit

class CreateCardController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "CreateCardController"
	static var storyboardName: String = "Cards"
	
	@IBOutlet weak var nameTextField: LoloTextField!
	@IBOutlet weak var numberTextField: CreditCardTextField!
	@IBOutlet weak var expirationTextField: ExpirationDateTextField!
	@IBOutlet weak var cvvTextField: LoloTextField!
	@IBOutlet weak var defaultCardCheckBox: CheckBox!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	
	private let repository = Repository()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareUI() {
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		saveButton.onTap {
			self.saveCard()
		}
	}
	
	private func saveCard() {
		
		guard let name = nameTextField.text, !name.isEmpty else {
			alert(message: "Ingrese el nombre"); return
		}
		
		guard let number = numberTextField.text, number.count >= 15 else {
			alert(message: "Ingrese un número de tarjeta válido"); return
		}
		
		guard expirationTextField.isValid(),
			let expiration = expirationTextField.text, expiration.count == 5 else {
			alert(message: "Ingrese fecha de expiración válida"); return
		}
		
		guard let cvv = cvvTextField.text, cvv.count == 3 else {
			alert(message: "Ingrese número CVV"); return
		}
		
		let cardNumber = number.replacingOccurrences(of: " ", with: kEmptyString)
		let isDefault = defaultCardCheckBox.isSelected ? 1 : 0
		let data = CreateCardRequest(name: name, number: cardNumber, expiration: expiration, cvv: cvv, isDefault: isDefault)
		
		showSpinner()
		repository.createCard(data: data, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if response.succeed {
					self?.mainNavigationController.alert(message: "¡Listo!", icon: "ic_cards_rounded", completion: {
						self?.mainNavigationController.navigateBack()
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
