//
//  Screen.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import Foundation

enum NavigationContext {
	case checkout
	case normal
}

enum Screen {
	case addresses
	case brand(Brand)
	case categories
	case cards
	case cart
	case createCard
	case createAddress(Double, Double)
	case favorites
	case history
	case historyDetail(Int)
	case landing
	case login
	case menu
	case map
	case onboarding
	case orderResume // resumen de la orden (paso 3)
	case orderConfirmation // mensaje de confirmacion de la orden
	case points
	case products(Category)
	case productDetail(Product)
	case restaurants
	case search
	case selectPaymentMethod
	case selectAddress
	case updateAddress(Address)
	case updateCard(Int)
	case updateProductInCart(Producto)
	case verifyCode
	case verifyInformation
	case verifiedAccountConfirmation
}

extension Screen {
	
	var description: String {
		"\(self)"
	}
}
