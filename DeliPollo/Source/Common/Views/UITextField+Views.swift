//
//  LoloTextField.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 23/12/20.
//

import UIKit

// MARK: - Lolo TextField

final class LoloTextField: UITextField {
	
	@IBInspectable var maxLenght: Int = 0 {
		didSet {
			if maxLenght > 0 {
				delegate = self
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		prepareUI()
	}
	
	func prepareUI() {
		let padding: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
		leftView = padding
		leftViewMode = .always
		layer.cornerRadius = 8
		layer.borderWidth = 2
		layer.borderColor = UIColor.loloBlue.cgColor
		backgroundColor = .white
		textColor = UIColor.loloGray
		font = UIFont.bloggerSans(size: 20, bold: true)
		borderStyle = .none
	}
}

extension LoloTextField: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if maxLenght == 0 {
			return true
		}
		
		let text = textField.text ?? kEmptyString
		let length = text.count + string.count
		return length <= maxLenght
	}
}

// MARK: - Credit Card TextField

final class CreditCardTextField: UITextField {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		prepareUI()
	}
	
	func prepareUI() {
		layer.cornerRadius = 8
		layer.borderWidth = 2
		layer.borderColor = UIColor.loloBlue.cgColor
		backgroundColor = .white
		borderStyle = .none
		textAlignment = .center
		textColor = UIColor.loloGray
		font = UIFont.bloggerSans(size: 20, bold: true)
		keyboardType = .numberPad
		addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
		delegate = self
	}
	
	@objc func didChangeText(textField: UITextField) {
		textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
	}
	
	func modifyCreditCardString(creditCardString: String) -> String {
		 let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
		 let arrOfCharacters = Array(trimmedString)
		 var modifiedCreditCardString = kEmptyString
		 if arrOfCharacters.count > 0 {
			 for index in 0...arrOfCharacters.count - 1 {
				 modifiedCreditCardString.append(arrOfCharacters[index])
				
				 if (index + 1) % 4 == 0 && index + 1 != arrOfCharacters.count {
					 modifiedCreditCardString.append(" ")
				 }
			 }
		 }
		 return modifiedCreditCardString
	}
}

extension CreditCardTextField: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let newLength = (textField.text ?? kEmptyString).count + string.count - range.length
		return newLength <= 19
	}
}

// MARK: - Expiration Date TextField

final class ExpirationDateTextField: UITextField {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		prepareUI()
	}
	
	func prepareUI() {
		layer.cornerRadius = 8
		layer.borderWidth = 2
		layer.borderColor = UIColor.loloBlue.cgColor
		backgroundColor = .white
		borderStyle = .none
		textAlignment = .center
		textColor = UIColor.loloGray
		font = UIFont.bloggerSans(size: 20, bold: true)
		keyboardType = .numberPad
		delegate = self
	}
	
	func validate(dateString: String) {

		// This will give you current year (i.e. if 2019 then it will be 19)
		let currentYear = Calendar.current.component(.year, from: Date()) % 100
		// This will give you current month (i.e if June then it will be 6)
		let currentMonth = Calendar.current.component(.month, from: Date())
		// get last two digit from entered string as year
		let enteredYear = Int(dateString.suffix(2)) ?? 0
		// get first two digit from entered string as month
		let enteredMonth = Int(dateString.prefix(2)) ?? 0

		if enteredYear > currentYear {
			if (1 ... 12).contains(enteredMonth) {
				print("Entered Date Is Right")
			} else {
				print("Entered Date Is Wrong")
			}
		} else if currentYear == enteredYear {
			if enteredMonth >= currentMonth {
				if (1 ... 12).contains(enteredMonth) {
				   print("Entered Date Is Right")
				} else {
				   print("Entered Date Is Wrong")
				}
			} else {
				print("Entered Date Is Wrong")
			}
		} else {
		   print("Entered Date Is Wrong")
		}

	}
	
	@discardableResult func isValid() -> Bool {

		let currentYear = Calendar.current.component(.year, from: Date()) % 100
		let currentMonth = Calendar.current.component(.month, from: Date())
		let enteredYear = Int(self.text!.suffix(2)) ?? 0
		let enteredMonth = Int(self.text!.prefix(2)) ?? 0
		
		if enteredYear > currentYear {
			if (1 ... 12).contains(enteredMonth) {
				return true
			} else {
				return false
			}
		} else if currentYear == enteredYear {
			if enteredMonth >= currentMonth {
				if (1 ... 12).contains(enteredMonth) {
					return true
				} else {
					return false
				}
			} else {
				return false
			}
		} else {
			return false
		}
	}
}

extension ExpirationDateTextField: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let oldText = textField.text,
			  let oldTextRange = Range(range, in: oldText) else { return true }
		let updatedText = oldText.replacingCharacters(in: oldTextRange, with: string)
		
		if string == kEmptyString {
			if updatedText.count == 2 {
				textField.text = "\(updatedText.prefix(1))"
				return false
			}
		} else if updatedText.count == 1 {
			if updatedText > "1" {
				return false
			}
		} else if updatedText.count == 2 {
			// Prevent user to not enter month more than 12
			if updatedText <= "12" {
				// This will add "/" when user enters 2nd digit of month
				textField.text = "\(updatedText)/"
			}
			return false
		} else if updatedText.count == 5 {
			self.validate(dateString: updatedText)
		} else if updatedText.count > 5 {
			return false
		}
		return true
   }
}
