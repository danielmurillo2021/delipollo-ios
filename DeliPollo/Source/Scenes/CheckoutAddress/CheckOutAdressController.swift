//
//  CheckOutAdressController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/11/21.
//

import UIKit

class CheckOutAdressController: DPViewController, StoryboardLoadable {
    
    static var storyboardId: String = "CheckOutAdressController"
    static var storyboardName: String = "Addresses"
	
	/// cantidad de lineas visibles en lista de sucursales
    private var rows = 8
    
    private let repository: Repository = Repository()
    
    private(set) var addresses: [Address] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.heightConstraint.constant = CGFloat(self.addresses.count * 78)
                self.separatorView.isHidden = self.addresses.isEmpty
            }
        }
    }
    
    private var branches: [Branch] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableBranch.reloadData()
            }
        }
    }
	
	private var selectedBranchIndex: Int = 0
	private var address: Address?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableBranch: UITableView!
    @IBOutlet weak var brachHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var branchButton: UIButton!
    @IBOutlet weak var branchCheck: CheckBox!
    @IBOutlet weak var controlsStack: UIStackView!
    @IBOutlet weak var upTableButton: UIButton!
    @IBOutlet weak var downTableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        loadBrands()
    }
    
    private func prepareUI() {
        tableView.separatorStyle = .none
        tableView.register(CheckOutAddressCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableBranch.separatorStyle = .none
        tableBranch.register(CheckOutBranchCell.self)
        tableBranch.dataSource = self
        tableBranch.delegate = self
        
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
            self.mainNavigationController.set(screen: .map)
        }
        
        nextButton.onTap { [weak self] in
			if let selectedAddress = self?.address,
			   let brandCode = CheckoutManager.shared.getBrandCode() {
				self?.validateAddress(selectedAddress: selectedAddress, brandCode: brandCode)
				
			} else if let index = self?.selectedBranchIndex,
					  let branch = self?.branches[index] {
				CheckoutManager.shared.setBranch(branch: branch)
				self?.mainNavigationController.set(screen: .selectPaymentMethod)
				
			} else {
				self?.alert(message: "Seleccione una dirección de envío o sucursal para retirar")
			}
        }
        
        branchButton.onTap {
            self.address = nil
            self.tableView.reloadData()
            self.branchCheck.isSelected = true
            self.brachHeightConstraint.constant = CGFloat(self.rows * 24)
            self.brandNameLabel.isHidden = false
            self.controlsStack.isHidden = false
            self.view.layoutIfNeeded()
        }
        
        upTableButton.onTap {
			if self.selectedBranchIndex > 1 {
				self.selectedBranchIndex -= 1
				let indexPath = IndexPath(row: self.selectedBranchIndex, section: 0)
				self.tableBranch.scrollToRow(at: indexPath, at: .top, animated: true)
				self.tableBranch.reloadData()
			}
        }
        
        downTableButton.onTap {
			if self.selectedBranchIndex < self.branches.count - 1 {
				self.selectedBranchIndex += 1
				let indexPath = IndexPath(row: self.selectedBranchIndex, section: 0)
				self.tableBranch.scrollToRow(at: indexPath, at: .top, animated: true)
				self.tableBranch.reloadData()
			}
        }
        
        updateBranchView()
    }
	
	func validateAddress(selectedAddress: Address, brandCode: String) {
		self.showSpinner()
		self.repository.validateCoverage(brand: brandCode, latitude: selectedAddress.latitude.doubleValue, longitude: selectedAddress.longitude.doubleValue, completion: { [weak self] result in
			
			self?.hideSpinner()
			switch result {
			case let .success(response):
				if response.succeed {
					CheckoutManager.shared.setAddress(address: selectedAddress)
					self?.mainNavigationController.set(screen: .selectPaymentMethod)
				} else {
					self?.alert(message: response.message)
				}
			case let .failure(error):
				self?.processError(error)
			}
		})
	}
    
    func updateBranchView() {
        self.branchCheck.isSelected = false
        brachHeightConstraint.constant = 0
        controlsStack.isHidden = true
        brandNameLabel.isHidden = true
        view.layoutIfNeeded()
    }
    
    private func loadData() {
        repository.getAddresses(cache: { [weak self] response in
            if let data = response.data {
                self?.addresses = data.sorted(by: { $0.isDefault > $1.isDefault })
            }
        }, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let data = response.data {
                    self?.addresses = data.sorted(by: { $0.isDefault > $1.isDefault })
                }
            case .failure(let error):
                self?.processError(error)
            }
        })
    }
    
    private func loadBrands() {
		guard let brandCode = CheckoutManager.shared.getBrandCode() else { return }
		repository.getBranches(brand: brandCode, cache: { cache in
			if let data = cache.data {
				self.branches = data
			}
        }, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let data = response.data {
					self?.branches = data
                }
            case .failure(let error):
				self?.processError(error)
            }
        })
    }
}

extension CheckOutAdressController: UITableViewDataSource {
	
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tableView == tableBranch ? branches.count : addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableBranch {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckOutBranchCell.reuseIdentifier, for: indexPath) as? CheckOutBranchCell ?? CheckOutBranchCell()
            let item = branches[indexPath.row]
            cell.branchLabel.text = "· \(item.name)"
			
			if self.branches[selectedBranchIndex].id == item.id {
				cell.backgroundColor = UIColor.loloBlue.withAlphaComponent(0.5)
			} else {
				cell.backgroundColor = .none
			}
            
            cell.addTapGesture(handler: { _ in
				self.selectedBranchIndex = indexPath.row
                self.address = nil
                cell.isSelected = true
                self.tableBranch.reloadData()
            })
			
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckOutAddressCell.reuseIdentifier, for: indexPath) as? CheckOutAddressCell ?? CheckOutAddressCell()
            let address = self.addresses[indexPath.row]
            cell.nameLabel.text = address.name
            cell.addressLabel.text = address.summary
            cell.checkAddress.isUserInteractionEnabled = false
            
            if let userAddress = self.address {
                cell.checkAddress.isSelected = userAddress.id == address.id
            } else {
                cell.checkAddress.isSelected = false
            }
            
            cell.addTapGesture(handler: { _ in
                cell.checkAddress.isSelected = !cell.checkAddress.isSelected
                self.address = address
				self.selectedBranchIndex = 0
                self.tableView.reloadData()
                self.updateBranchView()
            })
			
            return cell
        }
    }
    
}

extension CheckOutAdressController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		tableView == self.tableBranch ? 24 : 74
    }
}
