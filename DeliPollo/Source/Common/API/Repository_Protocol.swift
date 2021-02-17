//
//  Repository_Protocol.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import Foundation

// swiftlint:disable all

protocol RepositoryProtocol {
	
	func validateEmail(email: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void)
	
	func login(phone: String, code: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void)
	
	func signin(phone: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void)
	
	func activateAccount(token: String, code: String, completion: @escaping (Result<HTTPResponse<TokenResponse>, APIError>) -> Void)
	
	func getUserProfile(completion: @escaping (Result<HTTPResponse<ProfileResponse>, APIError>) -> Void)
	
	func updateProfile(data: UpdateProfile, completion: @escaping (Result<HTTPResponse<ProfileResponse>, APIError>) -> Void)
	
	func getInductions(cache: (HTTPResponse<[Induction]>) -> Void, completion: @escaping (Result<HTTPResponse<[Induction]>, APIError>) -> Void)
	
	func getPromotions(cache: (HTTPResponse<[Promotion]>) -> Void, completion: @escaping (Result<HTTPResponse<[Promotion]>, APIError>) -> Void)
	
	func getBrands(cache: (HTTPResponse<[Brand]>) -> Void, completion: @escaping (Result<HTTPResponse<[Brand]>, APIError>) -> Void)
	
	func getBranches(brand: String, cache: (HTTPResponse<[Branch]>) -> Void, completion: @escaping (Result<HTTPResponse<[Branch]>, APIError>) -> Void)
	
	func getCategories(cache: (HTTPResponse<[Category]>) -> Void, completion: @escaping (Result<HTTPResponse<[Category]>, APIError>) -> Void)
	
	func getPaymentTypes(cache: (HTTPResponse<[TipoPago]>) -> Void, completion: @escaping (Result<HTTPResponse<[TipoPago]>, APIError>) -> Void)
	
	func getAddresses(cache: (HTTPResponse<[Address]>) -> Void, completion: @escaping (Result<HTTPResponse<[Address]>, APIError>) -> Void)
	
	func createAddress(data: CreateAddressRequest, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func updateAddress(data: UpdateAddressRequest, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func deleteAddress(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func setDefaultAddress(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func getCards(cache: (HTTPResponse<[Card]>) -> Void, completion: @escaping (Result<HTTPResponse<[Card]>, APIError>) -> Void)
	
	func createCard(data: CreateCardRequest, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func deleteCard(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func setDefaultCard(id: Int, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func getProducts(cache: (HTTPResponse<[Product]>) -> Void, completion: @escaping (Result<HTTPResponse<[Product]>, APIError>) -> Void)
	
	func getProduct(productId: String, companyId: String, completion: @escaping (Result<HTTPResponse<Product>, APIError>) -> Void)
	
	func getOrders(cache: (HTTPResponse<[Orden]>) -> Void, completion: @escaping (Result<HTTPResponse<[Orden]>, APIError>) -> Void)
	
	func getOrderDetail(id: Int, completion: @escaping (Result<HTTPResponse<DetalleOrden>, APIError>) -> Void)
	
	func getQuestions(cache: (HTTPResponse<[Pregunta]>) -> Void, completion: @escaping (Result<HTTPResponse<[Pregunta]>, APIError>) -> Void)
	
	func getPicture(completion: @escaping (Result<HTTPResponse<Picture>, APIError>) -> Void)
	
	func setPicture(_ base64String: String, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
	
	func validateCoverage(brand: String, latitude: Double, longitude: Double, completion: @escaping (Result<HTTPResponse<BranchCoverage>, APIError>) -> Void)
	
	func insertOrder(_ data: InsertarOrden, completion: @escaping (Result<HTTPResponse<OrderResponse>, APIError>) -> Void)
	
	func addRatings(data: InsertarValoracion, completion: @escaping (Result<HTTPResponse<Value>, APIError>) -> Void)
}
