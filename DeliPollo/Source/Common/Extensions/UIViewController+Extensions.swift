//
//  UIViewController+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit
import JGProgressHUD
import Toaster

// swiftlint:disable all
extension UIViewController {
	
	func toast(_ message: String) {
		DispatchQueue.main.async {
			let toast = Toast(text: message, delay: Delay.short, duration: Delay.short)
			toast.show()
		}
	}
	
	func processError(_ error: APIError) {
		switch error {
		case .internetConnection:
			toast("No tiene conexión a internet")
		case .unknown(let message):
			alert(message: message)
		case .forbidden:
			IntroController.loadAsync(completion: {
				self.present($0, animated: true, completion: nil)
			})
		default:
			alert(message: kErrorOcurred)
		}
	}
	
	func showSpinner(animated: Bool = true) {
		DispatchQueue.main.async {
			self.view.endEditing(true)
			let hud = JGProgressHUD(style: .dark)
			hud.tag = 619
			hud.alpha = 0
			hud.show(in: self.view, animated: animated)
			hud.alpha = 1
		}
	}

	func hideSpinner() {
		DispatchQueue.main.async {
			self.view.endEditing(true)
			guard let hud = self.view.viewWithTag(619) as? JGProgressHUD else { return }
			hud.dismiss(animated: true)
		}
	}
	
	func alert(title: String = "Mensaje", message: String, confirmButtonText: String = "Aceptar", showCancelButton: Bool = false, callback: (() -> Void)? = nil, cancelCallback:  (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		alertController.addAction(UIAlertAction(title: confirmButtonText, style: .default, handler: { _ in
			if let callback = callback {
				callback()
			}
		}))
		
		if showCancelButton {
			alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
				if let callback = cancelCallback {
					callback()
				}
			}))
		}
		
		DispatchQueue.main.async {
			self.present(alertController, animated: true, completion: nil)
		}
	}
}
