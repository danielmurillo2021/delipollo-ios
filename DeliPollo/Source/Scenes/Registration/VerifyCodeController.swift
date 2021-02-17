//
//  VerifyNumberController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 23/12/20.
//

import UIKit

class VerifyCodeController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "VerifyCodeController"
	static var storyboardName: String = "Login"
	
	private let repository = Repository()
	
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var codeTextField: LoloTextField!
	@IBOutlet weak var termsCheckBox: CheckBox!
	
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
		
		termsCheckBox.isSelected = true
		
		if let phone = Session.shared.getUserPhone() {
			numberLabel.text = "+\(phone)"
		}
	}

	@IBAction func nextButtonTapped(_ sender: UIButton) {
		
		guard termsCheckBox.isSelected else {
			self.alert(message: "Debe aceptar los términos y condiciones"); return
		}
		
		guard let code = codeTextField.text, code.count == 4 else {
			self.alert(message: "Ingrese un código válido"); return
		}
		
		guard let token = Session.shared.getRegistrationToken() else {
			self.alert(message: "Error en el proceso de registro, intente de nuevo"); return
		}
		
		showSpinner()
		repository.activateAccount(token: token, code: code, completion: { [weak self] result in
			self?.hideSpinner()
			switch result {
			case .success(let response):
				if let token = response.data?.token {
					Session.shared.setUserToken(token)
					self?.navigateToCompleteProfile()
				} else {
					self?.alert(message: "Error en el proceso de registro, intente de nuevo")
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func navigateToCompleteProfile() {
		CompleteProfileController.loadAsync(completion: {
			self.present($0, animated: true, completion: nil)
		})
	}
}
