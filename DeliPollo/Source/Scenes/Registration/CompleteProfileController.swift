//
//  CompleteProfileController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 23/12/20.
//

import UIKit

class CompleteProfileController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "CompleteProfileController"
	static var storyboardName: String = "Login"
	
	private let repository = Repository()
	
	@IBOutlet weak var nameTextField: LoloTextField!
	@IBOutlet weak var lastnameTextField: LoloTextField!
	@IBOutlet weak var emailTextField: LoloTextField!
	@IBOutlet weak var pinView: LoloCodeInsertView!
	@IBOutlet weak var confirmPinView: LoloCodeInsertView!
	
	deinit {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addTapGesture(handler: { _ in
			self.view.endEditing(true)
		})
	}
	
	@IBAction func nextButtonTapped(_ sender: Any) {
		validateEmail()
	}
	
	private func validateEmail() {
		guard let email = emailTextField.text else {
			self.alert(message: "Inserte los datos correctamente"); return
		}
		
		showSpinner()
		repository.validateEmail(email: email, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if response.succeed {
					DispatchQueue.main.async {
						self?.updateProfile()
					}
				} else {
					self?.alert(message: "Dirección de correo electrónico no es válida para ser registrada.")
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func updateProfile() {
		guard let name = nameTextField.text,
			  let lastname = lastnameTextField.text,
			  let email = emailTextField.text else {
			self.alert(message: "Inserte los datos correctamente"); return
		}
		
		let pin = pinView.getCode()
		let confirmatedPin = confirmPinView.getCode()
		
		guard pin == confirmatedPin else {
			self.alert(message: "El pin no coincide"); return
		}
		
		let data = UpdateProfile(name: name, lastname: lastname, email: email, password: pin, passwordConfirmation: confirmatedPin)
		
		self.showSpinner()
		repository.updateProfile(data: data, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if let data = response.data {
					Session.shared.setUser(name: data.name, lastname: data.lastname, email: data.email)
					Session.shared.setUserPhone(data.phone)
					self?.navigateToConfirmation()
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func navigateToConfirmation() {
		AccountConfirmationController.loadAsync(completion: {
			self.present($0, animated: true, completion: nil)
		})
	}
	
}
