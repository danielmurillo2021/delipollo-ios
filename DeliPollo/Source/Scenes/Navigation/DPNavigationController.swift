//
//  DPNavigationController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit
import Combine

final class DPNavigationController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "DPNavigationController"
	static var storyboardName: String = "Navigation"

	private var currentScreen: Screen = .menu
	private var navigationStack: [Screen] = []
	
	/// manejar el contexto si esta en checkout o en flujo normal... para facilitar la navegacion hacia atras 🍺
	private(set) var context: NavigationContext = .normal
	
	private var bindings = Set<AnyCancellable>()
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var bottomBar: UIView!
	@IBOutlet weak var subtotalButton: UIButton!
	@IBOutlet weak var quantityLabel: UILabel!
	@IBOutlet weak var placeholderView: UIView!
	@IBOutlet weak var placeholderImageView: UIImageView!
	@IBOutlet weak var placeholderLabel: UILabel!
	@IBOutlet weak var restaurantsButton: UIButton!
	@IBOutlet weak var favoritesButton: UIButton!
	@IBOutlet weak var burgerButton: UIButton!
	@IBOutlet weak var bagButton: UIButton!
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		LocationManager.shared.start()
		containerView.isUserInteractionEnabled = true
		containerView.backgroundColor = .clear
		bottomBar.setLayerCorners(radius: 36, topLeftCorner: true, topRightCorner: true)
		subtotalButton.titleLabel?.adjustsFontSizeToFitWidth = true
		subtotalButton.titleLabel?.minimumScaleFactor = 0.5
		quantityLabel.layer.borderColor = UIColor.white.cgColor
		
		let inset: CGFloat = 16
		restaurantsButton.imageView?.contentMode = .scaleAspectFit
		restaurantsButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		favoritesButton.imageView?.contentMode = .scaleAspectFit
		favoritesButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		burgerButton.imageView?.contentMode = .scaleAspectFit
		burgerButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		bagButton.imageView?.contentMode = .scaleAspectFit
		bagButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		// setear pantalla inicial
		set(screen: .restaurants)
		
		CartManager.shared.$groups
			.receive(on: RunLoop.main)
			.sink(receiveValue: { [weak self] _ in
				self?.updateCartInfo()
			})
			.store(in: &bindings)
	}
	
	private func updateCartInfo() {
		self.subtotalButton.setTitle(CartManager.shared.getSubtotal().currency, for: .normal)
		self.quantityLabel.isHidden = CartManager.shared.getQuantity() == 0
		self.quantityLabel.text = CartManager.shared.getQuantity().description
	}
	
	func loginAlert() {
		MustLoginController.loadAsync(completion: { controller in
			controller.modalPresentationStyle = .overFullScreen
			self.present(controller, animated: true, completion: nil)
		})
	}
	
	func alert(message: String, icon: String, completion: (() -> Void)?) {
		AlertController.loadAsync(completion: { controller in
			controller.message = message
			controller.icon = icon
			controller.okAction = completion
			controller.modalPresentationStyle = .overFullScreen
			self.present(controller, animated: true, completion: nil)
		})
	}
	
	func logout() {
		let controller = Session.shared.userIsAuthenticated()
			? LogoutController.loadFromStoryboard()
			: IntroController.loadFromStoryboard()
		
		controller.modalPresentationStyle = .overFullScreen
		present(controller, animated: true, completion: nil)
	}
	
	func navigateBack() {
		guard navigationStack.count > 0 else { return }
		let lastItem = navigationStack.removeLast()
		handleScreen(lastItem)
	}
	
	func set(screen: Screen) {
		guard screen.description != currentScreen.description else { return }
		if screen.description != "search" {
			if navigationStack.count == 50 {
				navigationStack.removeFirst() // maximo 50 items
			}
			navigationStack.append(currentScreen)
			#if DEBUG
			print("--> Navigation stack items count: \(navigationStack.count)")
			#endif
		}
		handleScreen(screen)
	}
	
	private func handleScreen(_ screen: Screen) {
		var controller: DPViewController?
		currentScreen = screen
		switch screen {
		case .brand(let brand):
			let brandController = BrandController.loadFromStoryboard()
			brandController.brand = brand
			setController(brandController)
		case .favorites:
			context = .normal
			controller = FavoritesController.loadFromStoryboard()
		case .categories:
			context = .normal
			controller = CategoriesController.loadFromStoryboard()
		case .menu:
			context = .normal
			MenuController.loadAsync(completion: { [weak self] in
				self?.setController($0)
			})
		case .restaurants:
			context = .normal
			controller = RestaurantsController.loadFromStoryboard()
		case .products(let category):
			let productsController = ProductsController.loadFromStoryboard()
			productsController.category = category
			setController(productsController)
		case .productDetail(let product):
			let productDetailController = ProductDetailController.loadFromStoryboard()
			productDetailController.product = product
			setController(productDetailController)
		case .addresses:
			controller = AddressesController.loadFromStoryboard()
		case .map:
			controller = MapController.loadFromStoryboard()
			
		case .createAddress(let latitude, let longitude):
			let createAddressController = CreateAddressController.loadFromStoryboard()
			createAddressController.latitude = latitude
			createAddressController.longitude = longitude
			setController(createAddressController)
			
		case .updateAddress(let address):
			let updateAddressController = CreateAddressController.loadFromStoryboard()
			updateAddressController.selectedAddress = address
			updateAddressController.isUpdating = true
			setController(updateAddressController)
			
		case .cards:
			controller = CardsController.loadFromStoryboard()
		case .createCard:
			controller = CreateCardController.loadFromStoryboard()
		case .history:
			controller = HistoryController.loadFromStoryboard()
		case .cart:
			context = .normal
			controller = CartController.loadFromStoryboard()
		case .orderResume:
			controller = CheckoutController.loadFromStoryboard()
		case .orderConfirmation:
			controller = OrderConfirmationController.loadFromStoryboard()
			updateCartInfo()
		case .selectAddress:
			context = .checkout
			CheckOutAdressController.loadAsync(completion: { [weak self] in
				self?.setController($0)
			})
		case .selectPaymentMethod:
			context = .checkout
			PaymentMethodController.loadAsync(completion: { [weak self] in
				self?.setController($0)
			})
			
		case .search:
			SearchController.loadAsync(completion: { [weak self] searchController in
				searchController.modalPresentationStyle = .overFullScreen
				searchController.view.backgroundColor = UIColor.loloBlue.withAlphaComponent(0.8)
				searchController.mainNavigationController = self
				self?.present(searchController, animated: true, completion: nil)
			})
			
		case .updateProductInCart(let producto):
			let detailController = ProductDetailController.loadFromStoryboard()
			detailController.updatingProduct = producto
			setController(detailController)
		case .historyDetail(let orderId):
			let detaildController = HistoryDetailController.loadFromStoryboard()
			detaildController.orderId = orderId
			setController(detaildController)
		case .points:
			controller = PointsController.loadFromStoryboard()
			
		default:
			controller = MenuController.loadFromStoryboard()
		}
		
		if let controller = controller {
			setController(controller)
		}
	}
	
	private func setController(_ controller: DPViewController) {
		DispatchQueue.main.async { [weak self] in
			self?.hidePlaceholder()
			if let childView = self?.containerView.subviews.first {
				UIView.transition(with: childView, duration: 0.2, options: .curveEaseIn, animations: {
					childView.alpha = 0.3
					childView.frame = CGRect(x: -childView.frame.width, y: 0, width: childView.frame.width, height: childView.frame.height)
				}, completion: { _ in
					childView.removeFromSuperview()
					self?.add(controller: controller)
				})
			} else {
				self?.add(controller: controller)
			}
		}
	}
	
	private func add(controller: DPViewController) {
		controller.mainNavigationController = self
		containerView.addSubview(controller.view)
		controller.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		controller.view.backgroundColor = .clear
		controller.view.frame = containerView.bounds
		controller.didMove(toParent: self)
	}
	
	@IBAction func categoriesButtonTapped(_ sender: Any) {
		set(screen: .categories)
	}
	
	@IBAction func favoritesButtonTapped(_ sender: Any) {
		set(screen: .favorites)
	}
	
	@IBAction func restaurantsButtonTapped(_ sender: Any) {
		set(screen: .restaurants)
	}
	
	@IBAction func cartButtonTapped(_ sender: Any) {
		set(screen: .cart)
	}
	
	@IBAction func totalButtonTapped(_ sender: Any) {
		set(screen: .cart)
	}
	
}

// MARK: - Placeholder methods

extension DPNavigationController {
	
	func hidePlaceholder() {
		DispatchQueue.main.async {
			self.placeholderView.isHidden = true
		}
	}
	
	func showPlaceholder(_ message: String, icon: String = "img_basket_empty") {
		DispatchQueue.main.async {
			self.placeholderView.isHidden = false
			self.placeholderLabel.text = message
			self.placeholderImageView.image = UIImage(named: icon)
		}
	}
}
