//
//  CheckoutController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/11/21.
//

import UIKit

class CheckoutController: DPViewController, StoryboardLoadable {
    
    static var storyboardId: String = "CheckoutController"
    static var storyboardName: String = "Checkout"
    
    private let repository: Repository = Repository()

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var titlePaymentLabel: UILabel!
    @IBOutlet weak var subTitlePaymentLabel: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var nameAddressLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!
	
	private var products: [Producto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
		
		restaurantLabel.text = CheckoutManager.shared.getBrandName()
		
		products = CheckoutManager.shared.getProducts()
		heightConstraint.constant = CGFloat(products.count * 100)
		
		subTotalLabel.text = CheckoutManager.shared.getSubtotal().currency
		deliveryLabel.text = CheckoutManager.shared.getDeliveryFee().currency
		totalLabel.text = CheckoutManager.shared.getTotal().currency
		
		preparePaymentMethod()
		prepareDelivery()
		
		tableView.register(CartProductCell.self)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = .clear
		
        backButton.onTap {
			self.mainNavigationController.navigateBack()
        }
        
        searchButton.onTap {
            self.mainNavigationController.set(screen: .search)
        }
        
        accountButton.onTap {
            self.mainNavigationController.set(screen: .menu)
        }
		
		checkOutButton.onTap { [weak self] in
			let data = CheckoutManager.shared.buildOrder()
			self?.repository.insertOrder(data, completion: { result in
				switch result {
				case let .success(response):
					if response.succeed {
						CheckoutManager.shared.clear()
						self?.mainNavigationController.set(screen: .orderConfirmation)
					} else {
						self?.alert(message: response.message)
					}
				case let .failure(error):
					self?.processError(error)
				}
			})
		}
    }
	
	private func preparePaymentMethod() {
		
		if let cash = CheckoutManager.shared.getCash() {
			paymentLabel.text = "Efectivo"
			paymentImage.isHidden = true
			titlePaymentLabel.text = "Cancela con \(cash.currency)"
			let change = cash - CheckoutManager.shared.getTotal()
			subTitlePaymentLabel.text = "Cambio: \(change.currency)"
		}
		
		if let card = CheckoutManager.shared.getCard() {
			paymentLabel.text = "Tarjeta"
			paymentImage.isHidden = false
			titlePaymentLabel.text = card.number
			subTitlePaymentLabel.text = card.name
			paymentImage.image = card.number.getCardTypeImage()
		}
	}
	
	private func prepareDelivery() {
		
		if let address = CheckoutManager.shared.getAddress() {
			nameAddressLabel.text = address.name.uppercased()
			addressLabel.text = address.summary
		}
		
		if let branch = CheckoutManager.shared.getBranch() {
			nameAddressLabel.text = "Prefiero retiralo"
			addressLabel.text = branch.name
		}
	}

}

extension CheckoutController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int { 1 }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		products.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CartProductCell.reuseIdentifier, for: indexPath) as? CartProductCell else { fatalError() }
		
		let product = products[indexPath.row]
		cell.nameLabel.text = product.descripcion
		cell.quantityLabel.text = product.cantidad.description
		cell.productImageView.setImage(product.foto ?? kEmptyString)
		cell.deleteButton.isHidden = true
		cell.subtotalLabel.text = product.subTotal.currency
		return cell
	}
}

extension CheckoutController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }
}
