//
//  MenuController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit
import Closures

class MenuController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "MenuController"
	static var storyboardName: String = "Menu"
	
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var pictureButton: UIButton!
	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var favoritesView: UIView!
	@IBOutlet weak var pointsView: UIView!
	@IBOutlet weak var historyView: UIView!
	@IBOutlet weak var addressesView: UIView!
	@IBOutlet weak var paymentMethodsView: UIView!
	@IBOutlet weak var logoutView: UIView!
	@IBOutlet weak var logoutLabel: UILabel!
	
	private var repostory: Repository = Repository()
	
	private var imagePicker: ImagePicker!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func updateViews() {
		addressesView.isHidden = true
		pointsView.isHidden = true
		paymentMethodsView.isHidden = true
		historyView.isHidden = true
		logoutLabel.text = "iniciar sesión"
	}
	
	private func prepareUI() {
		
		loadUserImage()
		
		imagePicker = ImagePicker(presentationController: self, delegate: self)
		
		if let email = Session.shared.getUserEmail() {
			emailLabel.text = email
		} else {
			emailLabel.text = kEmptyString
			updateViews()
		}
		
		if let fullname = Session.shared.getUserFullname() {
			nameLabel.text = fullname
		} else {
			nameLabel.text = kEmptyString
		}
		
		pictureButton.onTap {
			self.imagePicker.present(from: self.pictureButton)
		}
		
		closeButton.onTap {
			self.mainNavigationController.navigateBack()
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		pointsView.addTapGesture(handler: { _ in
			self.mainNavigationController.set(screen: .points)
		})
		
		favoritesView.addTapGesture(handler: { _ in
			self.mainNavigationController.set(screen: .favorites)
		})
		
		addressesView.addTapGesture(handler: { _ in
			self.mainNavigationController?.set(screen: .addresses)
		})
		
		historyView.addTapGesture(handler: { _ in
			self.mainNavigationController.set(screen: .history)
		})
		
		paymentMethodsView.addTapGesture(handler: { _ in
			self.mainNavigationController?.set(screen: .cards)
		})
		
		logoutView.addTapGesture(handler: { _  in
			self.mainNavigationController?.logout()
		})
	}
	
	func loadUserImage() {
		guard Session.shared.userIsAuthenticated() else { return }
		
		if let image = UIImage.retrieveImage(forKey: kProfileImage) {
			DispatchQueue.main.async {
				self.pictureImageView.image = image
			}
		} else {
			self.showSpinner()
			repostory.getPicture(completion: { [weak self] result in
				self?.hideSpinner()
				switch result {
				case let .success(response):
					if response.succeed {
						DispatchQueue.main.async {
							if let data = response.data, !data.file.isEmpty {
								self?.pictureImageView.image = data.file.convertToImage()
							}
						}
					}
				case let .failure(error):
					print(error)
				}
			})
		}
	}
	
}

extension MenuController: ImagePickerDelegate {

	func didSelect(image: UIImage?) {
		guard let image = image else { return }
		
		let scaledImage = image.scalePreservingAspectRatio()
		
		scaledImage.store(forKey: kProfileImage)
		self.pictureImageView.image = scaledImage
		repostory.setPicture(scaledImage.convertImageToBase64String(), completion: { [weak self] _ in
			self?.loadUserImage()
		})
	}
}
