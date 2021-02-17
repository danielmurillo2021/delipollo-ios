//
//  SignInController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 23/12/20.
//

import UIKit

class SigninController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "SigninController"
	static var storyboardName: String = "Login"
	
	@IBOutlet weak var numberTextField: LoloTextField!
	@IBOutlet weak var termsCheckBox: CheckBox!
	
	private var countryCode: String = "505"
	
	private let repository = Repository()
	
	deinit {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareUI() {
		view.addTapGesture(handler: { _ in
			self.view.endEditing(true)
		})
		
		termsCheckBox.isSelected = false
	}

	@IBAction func nextButtonTapped(_ sender: Any) {
		
		guard let phone = numberTextField.text, phone.count >= 8 else {
			self.alert(message: "Ingrese un número válido"); return
		}
		
		guard termsCheckBox.isSelected else {
			self.alert(message: "Debe aceptar los términos y condiciones"); return
		}
		
		showSpinner()
		let number = countryCode.appending(phone)
		repository.signin(phone: number, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if let token = response.data?.token {
					Session.shared.setUserPhone(number)
					Session.shared.setRegistrationToken(token)
					self?.navigateToVerifyCode()
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func navigateToVerifyCode() {
		VerifyCodeController.loadAsync(completion: {
			self.present($0, animated: true, completion: nil)
		})
	}
}
