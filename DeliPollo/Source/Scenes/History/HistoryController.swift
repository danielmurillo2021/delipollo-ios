//
//  HistoryController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 21/12/20.
//

import UIKit

class HistoryController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "HistoryController"
	static var storyboardName: String = "History"
    
    private let repository: Repository = Repository()
    
    private(set) var orders: [Orden] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.heightConstraint.constant = CGFloat(self.orders.count * 72)
				self.separatorView.isHidden = self.orders.isEmpty
				if self.orders.isEmpty {
					self.mainNavigationController.showPlaceholder("¡todavía no hay ordenes")
				} else {
					self.mainNavigationController.hidePlaceholder()
				}
            }
        }
    }
	
	private var brands: [Brand] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
	@IBOutlet weak var separatorView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadBrands()
		loadOrders()
		prepareUI()
	}
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
	private func prepareUI() {
        tableView.separatorStyle = .none
        tableView.register(HistoryCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
	}
    
    private func loadOrders() {
        repository.getOrders(cache: { [weak self] response in
            if let orders = response.data {
                self?.orders = orders
            }
        }, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let orders = response.data {
                    self?.orders = orders
                }
            case .failure(let error):
                self?.processError(error)
            }
        })
    }
	
	private func loadBrands() {
		repository.getBrands(cache: { cache in
			self.brands = cache.data ?? []
		}, completion: { result in
			switch result {
			case let .success(response):
				self.brands = response.data ?? []
			case let .failure(error):
				print(error)
			}
		})
	}
    
}

extension HistoryController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { orders.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseIdentifier, for: indexPath) as? HistoryCell ?? HistoryCell()
        let order = orders[indexPath.row]
        cell.dateLabel.text = order.fechaOrden
		cell.numberLabel.text = order.codOrden.description
		
		if let brand = brands.first(where: { $0.code == order.codMarca }) {
			cell.logoImage.setImage(brand.logo)
		} else {
			cell.logoImage.image = nil
		}
        
        cell.addTapGesture(handler: { _ in
            self.mainNavigationController.set(screen: .historyDetail(order.codOrden))
        })
		
        return cell
    }
}

extension HistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }
}
