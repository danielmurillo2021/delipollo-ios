//
//  LoginController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import UIKit

class LoginController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "LoginController"
	static var storyboardName: String = "Login"
	
	@IBOutlet weak var phoneTextField: LoloTextField!
	@IBOutlet weak var pinTextField: LoloCodeInsertView!
	@IBOutlet weak var countryCodeView: UIView!
	@IBOutlet weak var countryCodeLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var topStackView: UIStackView!
	@IBOutlet weak var pinLabel: UILabel!
	
	private var repository: Repository!
	private(set) var countryCode: String = kDefaultCountryCode
	private(set) var phone: String?
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		repository = Repository()
		
		// clear session data if navigates to login
		Session.shared.clear()
		
		// validate if user phone number exists
		phone = Session.shared.getUserPhone()
		if phone != nil {
			topStackView.isHidden = true
			pinLabel.isHidden = true
			titleLabel.text = "pin de seguridad"
			subtitleLabel.text = "para iniciar sesión ingresa tu pin de seguridad"
		}
		
		view.addTapGesture(handler: { _ in
			self.view.endEditing(true)
		})
		
		pinTextField.didChange = {
			self.login()
		}
	}
	
	@IBAction func loginButtonTapped(_ sender: Any) {
		login()
	}
	
	private func login() {
		
		if phone == nil {
			phone = phoneTextField.text
		}
		
		guard let phone = self.phone, !phone.isEmpty, !pinTextField.getCode().isEmpty else {
			self.alert(message: "ingrese los datos"); return
		}
		
		let number = countryCode.appending(phone)
		showSpinner()
		repository.login(phone: number, code: pinTextField.getCode(), completion: { [weak self] result in
			switch result {
			case .success(let response):
				if let token = response.data?.token {
					Session.shared.setUserToken(token)
					Session.shared.setUserPhone(phone)
					self?.getUserProfile()
				} else {
					self?.hideSpinner()
					self?.alert(message: "teléfono y/o pin incorrectos")
				}
			case .failure(let error):
				self?.hideSpinner()
				self?.processError(error)
			}
		})
	}
	
	private func getUserProfile() {
		repository.getUserProfile(completion: { [weak self] result in
			switch result {
			case .success(let response):
				if let data = response.data {
					Session.shared.setUser(name: data.name, lastname: data.lastname, email: data.email)
					self?.navigateToMainNavigation()
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func navigateToMainNavigation() {
		DPNavigationController.loadAsync(completion: {
			self.present($0, animated: true, completion: nil)
		})
	}
}
