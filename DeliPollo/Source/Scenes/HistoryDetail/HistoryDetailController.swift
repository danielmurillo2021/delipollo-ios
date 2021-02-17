//
//  HistoryDetailController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 1/13/21.
//

import UIKit

class HistoryDetailController: DPViewController, StoryboardLoadable {
    
    static var storyboardId: String = "HistoryDetailController"
    static var storyboardName: String = "History"
	
	var orderId: Int?
	
	var alreadyRated: Bool = false
    
	private var valoraciones: [Valoracion] = []
	
    private(set) var products: [DetalleOrdenProducto] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.heightConstraint.constant = CGFloat((self?.products.count ?? 0) * 80)
            }
        }
    }
    
    private(set) var questions: [Pregunta] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
				self?.tableQuestions.reloadData()
				self?.heightQuestionsConstraint.constant = CGFloat((self?.questions.count ?? 0) * 80)
            }
        }
    }
	
	private(set) var brands: [Brand] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
    
    private let repository: Repository = Repository()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var totalOrder: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
	@IBOutlet weak var paymentTitle: UILabel!
	@IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var paymentDetail: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var addressDetail: UILabel!
    @IBOutlet weak var tableQuestions: UITableView!
    @IBOutlet weak var heightQuestionsConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var ratingLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		loadBrands()
		loadData()
		loadQuestions()
        prepareUI()
    }
    
    private func prepareUI() {
        tableView.separatorStyle = .none
        tableView.register(HistoryProductCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableQuestions.separatorStyle = .none
        tableQuestions.register(QuestionCell.self)
        tableQuestions.dataSource = self
        tableQuestions.delegate = self
        
        accountButton.onTap {
            self.mainNavigationController.set(screen: .menu)
        }
        
        searchButton.onTap {
            self.mainNavigationController.set(screen: .search)
        }
        
        backButton.onTap {
			self.mainNavigationController.navigateBack()
        }
		
		submitButton.onTap { [weak self] in
			let data = InsertarValoracion(codOrden: self?.orderId ?? 0,
										  valoraciones: self?.valoraciones ?? [])
			self?.showSpinner()
			self?.repository.addRatings(data: data, completion: { result in
				self?.hideSpinner()
				switch result {
				case .success(let response):
					if response.succeed {
						self?.alert(message: response.message)
						self?.loadData()
					}
				case .failure:
					self?.alert(message: kErrorOcurred)
				}
			})
		}
    }
    
    private func loadData() {
		guard let orderId = orderId else { return }
        repository.getOrderDetail(id: orderId, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if response.succeed {
                    if let order = response.data {
                        self?.products = order.productos
						self?.alreadyRated = order.estaValorada.boolValue
                        self?.loadInfo(order: order)
                    }
                } else {
                    self?.alert(message: kErrorOcurred)
                }
            case .failure(let error):
                self?.processError(error)
            }
        })
    }
    
    private func loadQuestions() {
		self.showSpinner()
        repository.getQuestions(cache: { [weak self] response in
            if let questions = response.data {
                self?.questions = questions
				self?.valoraciones = questions.map({
					Valoracion(codPregunta: $0.codPregunta, valor: 5, comentarios: kEmptyString)
				})
            }
        }, completion: { [weak self] result in
            switch result {
            case .success(let response):
                if let questions = response.data {
                    self?.questions = questions
					self?.hideSpinner()
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
    
    private func loadInfo(order: DetalleOrden) {
		DispatchQueue.main.async {
			
			if let brand = self.brands.first(where: { $0.code == order.codMarca }) {
				self.logoImage.setImage(brand.logo)
			} else {
				self.logoImage.image = nil
			}
			
			self.dateOrder.text = order.fechaOrden
			let total = PriceFormatter.shared.format(order.totalPago)
			self.totalOrder.text = total.currency
			
			self.paymentTitle.text = order.tipoPago
			
			if let card = order.tarjeta {
				self.paymentType.text = card.numero
				self.paymentDetail.text = card.nombre
				self.paymentImage.isHidden = false
				self.paymentImage.image = card.numero.getCardTypeImage()
			} else {
				self.paymentType.text = "Total \(order.totalPago.currency)"
				self.paymentDetail.text = "Cambio: \(order.cambio.currency)"
				self.paymentImage.isHidden = true
			}
			
			if let address = order.direccion {
				self.addressLabel.text = address.nombre.uppercased()
				self.addressType.text = address.direccion.uppercased()
			} else {
				self.addressLabel.text = order.direccionDesc
				self.addressType.text = order.sucursal?.nombre
			}
			
			self.addressDetail.text = kEmptyString
			
			self.ratingLabel.isHidden = self.alreadyRated
			self.submitButton.isHidden = self.alreadyRated
			
			self.tableView.reloadData()
			self.tableQuestions.reloadData()
		}
    }
}

extension HistoryDetailController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tableView == self.tableView ? products.count : (alreadyRated ? 0 :  questions.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryProductCell.reuseIdentifier, for: indexPath) as? HistoryProductCell ?? HistoryProductCell()
            let product = products[indexPath.row]
            cell.productLabel.text = product.descripcion
            cell.logoImage.setImage(product.urlImg)
			cell.qtyLabel.text = product.cantidad.description
			cell.cornerRadius = 8
			cell.selectionStyle = .none
            return cell
			
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.reuseIdentifier, for: indexPath) as? QuestionCell ?? QuestionCell()
            let question = questions[indexPath.row]
			
            cell.questionLabel.text = question.pregunta
			cell.ratingView.didChangeSelection = { value in
				self.valoraciones[indexPath.row].valor = value
			}
			
            return cell
        }
    }
}

extension HistoryDetailController: UITableViewDelegate {
    
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 80 }
}
