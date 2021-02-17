//
//  RepositoryImpl.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import Foundation

// swiftlint:disable all

final class Repository {
	
	private let client: HTTPClient
	private let realmManager: RealmManager
	
	init() {
		self.client = HTTPClient()
		self.realmManager = RealmManager.shared
	}
}

extension Repository: RepositoryProtocol {
	
	// MARK: - Authentication
	
	func validateEmail(email: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void) {
		let body = ["Email": email] as HTTPBody
		client.post(path: "/validaemail", body: body, type: HTTPResponse<TokenResponse>.self, forceToken: true, completion: completion)
	}
	
	func login(phone: String, code: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void) {
		let body = ["Telefono": phone, "Password": code, "EsExterno": "N"] as HTTPBody
		client.post(path: "/token", body: body, type: HTTPResponse<TokenResponse>.self, completion: completion)
	}
	
	func signin(phone: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void) {
		let body = ["Telefono": phone, "EsExterno": "N"] as HTTPBody
		client.post(path: "/registro", body: body, type: HTTPResponse<TokenResponse>.self, completion: completion)
	}
	
	func activateAccount(token: String, code: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void) {
		let body = ["TokenKey": token, "Codigo": code] as HTTPBody
		client.post(path: "/activacion", body: body, type: HTTPResponse<TokenResponse>.self, completion: completion)
	}
	
	// MARK: - User profile
	
	func getUserProfile(completion: @escaping (Result<HTTPResponse<ProfileResponse>, APIError>) -> Void) {
		client.get(path: "/usuario", type: HTTPResponse<ProfileResponse>.self, completion: completion)
	}
	
	func updateProfile(data: UpdateProfile, completion: @escaping (Result<HTTPResponse<ProfileResponse>, APIError>) -> Void) {
		client.post(path: "/usuario", body: data.dictionary!, type: HTTPResponse<ProfileResponse>.self, completion: completion)
	}
	
	// MARK: - Inductions
	
	func getInductions(cache: (HTTPResponse<[Induction]>) -> Void, completion: @escaping (Result<HTTPResponse<[Induction]>, APIError>) -> Void) {
		client.get(path: "/inducciones", type: HTTPResponse<[Induction]>.self, cache: cache, completion: completion)
	}
	
	// MARK: - Promotions
	
	func getPromotions(cache: (HTTPResponse<[Promotion]>) -> Void, completion: @escaping (Result<HTTPResponse<[Promotion]>, APIError>) -> Void) {
		client.get(path: "/imgpromociones", type: HTTPResponse<[Promotion]>.self, cache: cache, completion: completion)
	}
	
	// MARK: - Brands
	
	func getBrands(cache: (HTTPResponse<[Brand]>) -> Void, completion: @escaping (Result<HTTPResponse<[Brand]>, APIError>) -> Void) {
		client.get(path: "/marcas", type: HTTPResponse<[Brand]>.self, cache: cache, completion: completion)
	}
	
	// MARK: Branches
	
	func getBranches(brand: String, cache: (HTTPResponse<[Branch]>) -> Void, completion: @escaping (Result<HTTPResponse<[Branch]>, APIError>) -> Void) {
		client.get(path: "/sucursales?CodMarca=\(brand)", type: HTTPResponse<[Branch]>.self, cache: cache, completion: completion)
	}
	
	// MARK: - Categories
	
	func getCategories(cache: (HTTPResponse<[Category]>) -> Void, completion: @escaping (Result<HTTPResponse<[Category]>, APIError>) -> Void) {
		client.get(path: "/categorias", type: HTTPResponse<[Category]>.self, cache: cache, completion: completion)
	}
	
	// MARK: - Tipos de pago
	
	func getPaymentTypes(cache: (HTTPResponse<[TipoPago]>) -> Void, completion: @escaping (Result<HTTPResponse<[TipoPago]>, APIError>) -> Void) {
		client.get(path: "/tipospagos", type: HTTPResponse<[TipoPago]>.self, cache: cache, completion: completion)
	}
	
	// MARK: - Addresses
	
	func getAddresses(cache: (HTTPResponse<[Address]>) -> Void, completion: @escaping (Result<HTTPResponse<[Address]>, APIError>) -> Void) {
		client.get(path: "/direcciones", type: HTTPResponse<[Address]>.self, cache: cache, completion: completion)
	}
	
	func createAddress(data: CreateAddressRequest, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		client.post(path: "/direccioninsertar", body: data.dictionary!, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	func updateAddress(data: UpdateAddressRequest, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		client.post(path: "/direccionmodificar", body: data.dictionary!, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	func deleteAddress(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		let body = ["CodDireccion": id] as HTTPBody
		client.post(path: "/direccionbaja", body: body, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	func setDefaultAddress(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		let body = ["CodDireccion": id] as HTTPBody
		client.post(path: "/direccionpredeterminar", body: body, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	// MARK: - Cards
	
	func getCards(cache: (HTTPResponse<[Card]>) -> Void, completion: @escaping (Result<HTTPResponse<[Card]>, APIError>) -> Void) {
		client.get(path: "/tarjetas", type: HTTPResponse<[Card]>.self, cache: cache, completion: completion)
	}
	
	func createCard(data: CreateCardRequest, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		client.post(path: "/tarjetainsertar", body: data.dictionary!, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	func deleteCard(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		let body = ["CodTarjeta": id] as HTTPBody
		client.post(path: "/tarjetabaja", body: body, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	func setDefaultCard(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		let body = ["CodTarjeta": id] as HTTPBody
		client.post(path: "/tarjetamodificar", body: body, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	// MARK: - Products
	
	func getProducts(cache: (HTTPResponse<[Product]>) -> Void, completion: @escaping (Result<HTTPResponse<[Product]>, APIError>) -> Void) {
		client.get(path: "/productos", type: HTTPResponse<[Product]>.self, cache: cache, completion: completion)
	}
	
	func getProduct(productId: String, companyId: String, completion: @escaping (Result<HTTPResponse<Product>, APIError>) -> Void) {
		let url = "/producto?CodProducto=\(productId)&CodEmpresa=\(companyId)"
		client.get(path: url, type: HTTPResponse<Product>.self, completion: completion)
	}
	
	// MARK: - Orders
	
	func getOrders(cache: (HTTPResponse<[Orden]>) -> Void, completion: @escaping (Result<HTTPResponse<[Orden]>, APIError>) -> Void) {
		client.get(path: "/ordenes", type: HTTPResponse<[Orden]>.self, cache: cache, completion: completion)
	}
	
	func getOrderDetail(id: Int, completion: @escaping (Result<HTTPResponse<DetalleOrden>, APIError>) -> Void) {
		client.get(path: "/orden/\(id)", type: HTTPResponse<DetalleOrden>.self, completion: completion)
	}
	
	func getQuestions(cache: (HTTPResponse<[Pregunta]>) -> Void, completion: @escaping (Result<HTTPResponse<[Pregunta]>, APIError>) -> Void) {
		client.get(path: "/preguntas", type: HTTPResponse<[Pregunta]>.self, cache: cache, completion: completion)
	}
	
	// MARK: - User picture
	
	func getPicture(completion: @escaping (Result<HTTPResponse<Picture>, APIError>) -> Void) {
		client.get(path: "/fotousuario", type: HTTPResponse<Picture>.self, completion: completion)
	}
	
	func setPicture(_ base64String: String, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		let body = ["FotoUsuario": base64String] as HTTPBody
		client.post(path: "/fotousuario", body: body, type: HTTPResponse<Value>.self, completion: completion)
	}
	
	// MARK: - Validate coverage
	
	func validateCoverage(brand: String, latitude: Double, longitude: Double, completion: @escaping (Result<HTTPResponse<BranchCoverage>, APIError>) -> Void) {
		let body = ["CodMarca": brand, "Latitud": latitude, "Longitud": longitude] as HTTPBody
		client.post(path: "/validacobertura", body: body, type: HTTPResponse<BranchCoverage>.self, completion: completion)
	}
	
	// MARK: - Insert order
	
	func insertOrder(_ data: InsertarOrden, completion: @escaping (Result<HTTPResponse<OrderResponse>, APIError>) -> Void) {
		client.post(path: "/ordeninsertar", body: data.dictionary!, type: HTTPResponse<OrderResponse>.self, completion: completion)
	}
	
	// MARK: - Valoraciones
	func addRatings(data: InsertarValoracion, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void) {
		client.post(path: "/valoracion", body: data.dictionary!, type: HTTPResponse<Value>.self, completion: completion)
	}
}
