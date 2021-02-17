//
// PC GROUP SA
// DeliPollo - CheckoutManager.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 11/1/21
// Copyright © 2021. All rights reserved.

import Foundation

/// Maneja informacion del checkout en proceso
final class CheckoutManager {
	
	static var shared = CheckoutManager()
	
	// variables
	
	private var selectedGroup: CartGroup?
	private var selectedCard: Card?
	private var selectedAddress: Address?
	private var selectedCash: Double?
	private var selectedBranch: Branch?
	
	private var paymentTypes: [TipoPago] = []
	private var repository: Repository = Repository()
	
	private init() {}
	
	func clear() {
		
		if let group = selectedGroup {
			CartManager.shared.removeGroup(group.brandCode)
		}
		
		selectedGroup = nil
		selectedCard = nil
		selectedAddress = nil
		selectedCash = nil
		selectedBranch = nil
	}
	
	func setGroup(_ group: CartGroup) {
		self.selectedGroup = group
		
		// update payment types
		repository.getPaymentTypes(cache: { cache in
			self.paymentTypes = cache.data ?? []
		}, completion: { result in
			switch result {
			case .success(let response):
				self.paymentTypes = response.data ?? []
			case .failure(let error):
				print(error)
			}
		})
	}
	
	func setCard(card: Card) {
		self.selectedCard = card
		self.selectedCash = nil
	}

	func setCash(cash: Double) {
		self.selectedCash = cash
		self.selectedCard = nil
	}

	func setAddress(address: Address) {
		self.selectedAddress = address
	}

	func setBranch(branch: Branch) {
		self.selectedBranch = branch
	}
	
	func getSubtotal() -> Double {
		selectedGroup?.productos.getSubtotal() ?? 0
	}
	
	func getDeliveryFee() -> Double {
		selectedAddress?.fee ?? 0
	}
	
	func getTotal() -> Double {
		getSubtotal() + getDeliveryFee()
	}
	
	func getBrandCode() -> String? {
		selectedGroup?.brandCode
	}
	
	func getBrandName() -> String? {
		selectedGroup?.companyName
	}
	
	private func getCompanyCode() -> String {
		selectedGroup?.companyCode ?? kEmptyString
	}
	
	func getProducts() -> [Producto] {
		selectedGroup?.productos ?? []
	}
	
	func getCash() -> Double? {
		selectedCash
	}
	
	func getCard() -> Card? {
		selectedCard
	}
	
	func getAddress() -> Address? {
		selectedAddress
	}
	
	func getBranch() -> Branch? {
		selectedBranch
	}
	
	func buildOrder() -> InsertarOrden {
		var retiraEnSucursal = "N"
		var pagos: [Pago] = []
		
		if let card = selectedCard {
			let paymentTypeId = card.bank == "LAF" ? "6" : "3"
			pagos.append(Pago(aplicacionCupon: kDashString,
							  cambio: 0,
							  codTarjeta: card.id,
							  codTipoPago: paymentTypeId,
							  codigoBanco: paymentTypes.first { $0.codTipoPago == paymentTypeId }?.codTipoPago ?? kEmptyString,
							  descripcion: paymentTypes.first { $0.codTipoPago == paymentTypeId }?.descripcion ?? kEmptyString,
							  indiceFila: 1,
							  monto: getTotal(),
							  numeroCupon: kDashString,
							  pago: getTotal(),
							  valorCupon: 0))
		}
		
		if let cash = selectedCash {
			pagos.append(Pago(aplicacionCupon: kDashString,
							  cambio: cash - getTotal(),
							  codTarjeta: 0,
							  codTipoPago: paymentTypes.first { $0.codTipoPago == "1" }?.codTipoPago ?? "1",
							  codigoBanco: "00",
							  descripcion: "Efectivo",
							  indiceFila: 1,
							  monto: getTotal(),
							  numeroCupon: kDashString,
							  pago: getTotal(),
							  valorCupon: 0))
		}
		
		var sucursal = Sucursal(coberturaKM: kEmptyString,
								codEmpresa: getCompanyCode(),
								codSucursal: kEmptyString,
								departamento: kEmptyString,
								diasAtencion: kEmptyString,
								eslogan: kEmptyString,
								horaApertura: kEmptyString,
								horaCierre: kEmptyString,
								idSucursal: 0,
								latitud: kEmptyString,
								longitud: kEmptyString,
								nombre: kEmptyString,
								seleccionado: false,
								validaDiasAtencion: kEmptyString,
								validaHoraApertura: kEmptyString,
								validaHoraCierre: kEmptyString)
		// ༼ つ ಥ_ಥ ༽つ
		if let branch = selectedBranch {
			sucursal.coberturaKM = branch.coverage.description
			sucursal.codSucursal = branch.code
			sucursal.departamento = branch.departament
			sucursal.diasAtencion = branch.attentionDays
			sucursal.eslogan = branch.slogan
			sucursal.horaApertura = branch.openingHour
			sucursal.horaCierre = branch.closingHour
			sucursal.idSucursal = branch.id
			sucursal.latitud = branch.latitude
			sucursal.longitud = branch.longitude
			sucursal.nombre = branch.name
			sucursal.seleccionado = true
			sucursal.validaDiasAtencion = branch.validateAttentionDays
			sucursal.validaHoraApertura = branch.validateOpeningHour
			sucursal.validaHoraCierre = branch.validateClosingHour
			retiraEnSucursal = "S"
		}
		
		var direccion: Direccion?
		
		if let address = selectedAddress {
			direccion = Direccion(codDireccion: address.id,
								  tipoDireccion: address.type,
								  nombre: address.name,
								  direccion: address.summary,
								  telefono: kEmptyString,
								  departamento: address.department,
								  ciudad: address.city,
								  referencia: address.reference,
								  latitud: address.latitude,
								  longitud: address.longitude,
								  direccionGps: address.gps,
								  kilometros: address.kilometers,
								  valorTransporte: address.fee,
								  predeterminada: address.isDefault)
		}
		
		let order = InsertarOrden(aNombreDe: kEmptyString,
								  codMarca: getBrandCode() ?? kEmptyString,
								  codSegmento: kEmptyString,
								  comentarios: kEmptyString,
								  descuento: 0,
								  dispositivoID: kEmptyString,
								  fechaHoraEntrega: kEmptyString,
								  fechaHoraRetirar: kEmptyString,
								  identificacion: kEmptyString,
								  impuesto: 0,
								  os: String.OS,
								  pagos: pagos,
								  plataforma: String.OS,
								  productos: getProducts(),
								  retiraEnSucursal: retiraEnSucursal,
								  subTotal: getSubtotal(),
								  sucursal: sucursal,
								  total: getTotal(),
								  totalExonerado: 0,
								  transporte: getDeliveryFee(),
								  version: String.appVersion,
								  direccion: direccion)
		
		return order
	}
}
