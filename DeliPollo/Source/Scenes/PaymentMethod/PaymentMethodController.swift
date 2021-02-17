//
//  PaymentMethodController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/10/21.
//

import UIKit
import Combine

class PaymentMethodController: DPViewController, StoryboardLoadable {
    
    static var storyboardId: String = "PaymentMethodController"
    static var storyboardName: String = "PaymentMethod"
    
    private let repository: Repository = Repository()
	
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var cashPayment: CheckBox!
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cardPayment: CheckBox!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cashHeight: NSLayoutConstraint!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var paymentField: LoloTextField!
    @IBOutlet weak var firstLinePayment: UIView!
    @IBOutlet weak var secondLinePayment: UIView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private(set) var cards: [Card] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var card: Card!
	
	/// cantidad minima para aceptar efectivo
	private var minimumCashAmount: Double = 0
	
	private var bindings = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func prepareUI() {
        tableView.separatorStyle = .none
        tableView.register(CardCell.self)
        tableView.dataSource = self
        tableView.delegate = self
		
		cashPayment.type = .rounded
		cardPayment.type = .rounded
		
		minimumCashAmount = CheckoutManager.shared.getTotal()
		
		// pago en efectivo suggerido
		let suggestedCash = CheckoutManager.shared.getTotal().suggestedCash
		paymentField.text = suggestedCash.description
		let change = (minimumCashAmount - suggestedCash) * -1
		self.changeLabel.text = change > 0 ? change.currency : 0.0.currency
        
        backButton.onTap {
			self.mainNavigationController.navigateBack()
        }
        
        searchButton.onTap {
            self.mainNavigationController.set(screen: .search)
        }
        
        accountButton.onTap {
            self.mainNavigationController.set(screen: .menu)
        }
        
        cashButton.onTap {
            self.cashPayment.isSelected = !self.cashPayment.isSelected
            self.updateCashView()
        }
        
        cardButton.onTap {
            self.cardPayment.isSelected = !self.cardPayment.isSelected
            self.updateCardView()
        }
        
        addCardButton.onTap {
			self.mainNavigationController.set(screen: .createCard)
        }
        
        nextButton.onTap {
            if self.cardPayment.isSelected {
				self.validateCard()
            } else {
				self.validateCash()
            }
        }
		
		paymentField.textPublisher
			.receive(on: RunLoop.main)
			.map({ $0.doubleValue })
			.sink(receiveValue: { value in
				DispatchQueue.main.async {
					let change = (self.minimumCashAmount - value) * -1
					self.changeLabel.text = change > 0 ? change.currency : 0.0.currency
				}
			})
			.store(in: &bindings)
    }
	
	private func validateCard() {
		if let selectedCard = self.card {
			CheckoutManager.shared.setCard(card: selectedCard)
			self.mainNavigationController.set(screen: .orderResume)
		} else {
			self.alert(message: "Seleccione una tarjeta")
		}
	}
	
	private func validateCash() {
		let amount = paymentField.text?.doubleValue ?? 0
		if amount == 0 {
			self.alert(message: "Seleccione un método de pago")
		} else if amount < minimumCashAmount {
			self.alert(message: "El efectivo debe ser mayor a \(minimumCashAmount.currency)")
		} else {
			CheckoutManager.shared.setCash(cash: amount)
			self.mainNavigationController.set(screen: .orderResume)
		}
	}
    
    private func loadData() {
        repository.getCards(cache: { [weak self] response in
            if let cards = response.data {
                self?.cards = cards.sorted(by: { $0.isDefault > $1.isDefault })
            }
        }, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let cards = response.data {
                    self?.cards = cards.sorted(by: { $0.isDefault > $1.isDefault })
                }
            case .failure(let error):
                self?.processError(error)
            }
        })
    }
    
    func updateCashView() {
        view.layoutIfNeeded()
        if cashPayment.isSelected {
            cashHeight.constant = 124
            cardPayment.isSelected = false
            updateCardView()
        } else {
            cashHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.cashView.isHidden = !self.cashPayment.isSelected
        })
    }
    
    func updateCardView() {
        view.layoutIfNeeded()
		
        if cardPayment.isSelected {
            firstLinePayment.isHidden = true
            tableView.isHidden = false
			tableViewHeight.constant = CGFloat(self.cards.count * 100)
            addCardButton.isHidden = false
            secondLinePayment.isHidden = false
            paymentLabel.isHidden = false
            cashPayment.isSelected = false
            updateCashView()
        } else {
            firstLinePayment.isHidden = false
            tableView.isHidden = true
			tableViewHeight.constant = 0
            addCardButton.isHidden = true
            secondLinePayment.isHidden = true
            paymentLabel.isHidden = true
        }
    }
}

extension PaymentMethodController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cards.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.reuseIdentifier, for: indexPath) as? CardCell ?? CardCell()
        let card = cards[indexPath.row]
        cell.titleLabel.text = card.number
        cell.subtitleLabel.text = card.name
		cell.iconView.image = card.number.getCardTypeImage()
		cell.starView.isHidden = card.isDefault == 0
		cell.deleteButton.isHidden = true
        
        if let userCard = self.card {
            if userCard.id == card.id {
                cell.checkCard.isSelected = true
                cell.checkCard.isHidden = false
            } else {
                cell.checkCard.isSelected = false
                cell.checkCard.isHidden = true
            }
        }
        
        cell.addTapGesture(handler: { _ in
            self.card = card
            self.tableView.reloadData()
        })
        
        return cell
    }
}

extension PaymentMethodController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }
}
