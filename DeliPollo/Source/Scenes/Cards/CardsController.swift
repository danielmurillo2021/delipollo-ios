//
//  CardsController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit

class CardsController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "CardsController"
	static var storyboardName: String = "Cards"
	
	private let repository: Repository = Repository()
	
	private(set) var cards: [Card] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
				self.heightConstraint.constant = CGFloat(self.cards.count * 100)
				self.separatorView.isHidden = self.cards.isEmpty
				self.topConstraint.constant = self.cards.isEmpty ? 140 : 24
				self.addLabel.isHidden = !self.cards.isEmpty
			}
		}
	}
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var createButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	@IBOutlet weak var addLabel: UILabel!
	
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
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		createButton.onTap {
			self.mainNavigationController.set(screen: .createCard)
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
	
	private func delete(cardId: Int) {
		repository.deleteCard(id: cardId, completion: { [weak self] result in
			switch result {
			case .success(let response):
				if response.succeed {
					self?.loadData()
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
	
	private func setDefault(cardId: Int) {
		repository.setDefaultCard(id: cardId, completion: { [weak self] result in
			switch result {
			case .success(let response):
				if response.succeed {
					self?.loadData()
				} else {
					self?.alert(message: kErrorOcurred)
				}
			case .failure(let error):
				self?.processError(error)
			}
		})
	}
}

extension CardsController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int { 1 }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cards.count }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.reuseIdentifier, for: indexPath) as? CardCell ?? CardCell()
		let card = cards[indexPath.row]
		cell.titleLabel.text = card.number
		cell.subtitleLabel.text = card.name
		cell.iconView.image = card.number.getCardTypeImage()
		cell.starView.isHidden = card.isDefault == 0
		
		cell.deleteButton.onTap {
			self.delete(cardId: card.id)
		}
		
		return cell
	}
	
//	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//		let cardId = cards[indexPath.row].id
//
//		let deleteAction = UIContextualAction(style: .normal, title: kEmptyString, handler: { (_, _, completionHandler) in
//			self.delete(cardId: cardId)
//			completionHandler(true)
//		})
//
//		deleteAction.image = UIImage(systemName: "trash")
//		deleteAction.backgroundColor = .red
//
//		let setDefaultAction = UIContextualAction(style: .normal, title: kEmptyString, handler: { (_, _, completionHandler) in
//			self.setDefault(cardId: cardId)
//			completionHandler(true)
//		})
//
//		setDefaultAction.image = UIImage(systemName: "star")
//		setDefaultAction.backgroundColor = .loloBlue
//
//		let configuration = UISwipeActionsConfiguration(actions: [deleteAction, setDefaultAction])
//		return configuration
//	}
	
}

extension CardsController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }
}
