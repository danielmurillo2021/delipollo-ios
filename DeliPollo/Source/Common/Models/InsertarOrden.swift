//
// PC GROUP SA
// DeliPollo - OrderOption.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 11/1/21
// Copyright © 2021. All rights reserved.

import Foundation

// swiftlint:disable all

// NOTE: Se agregan modelos en español para evitar confusiones al enviar los datos ¯\_(ツ)_/¯

// MARK: - InsertarOrden

struct InsertarOrden: Codable {
	let aNombreDe, codMarca, codSegmento, comentarios: String
	let descuento: Double
	let dispositivoID, fechaHoraEntrega, fechaHoraRetirar, identificacion: String
	let impuesto: Double
	let os: String
	let pagos: [Pago]
	let plataforma: String
	let productos: [Producto]
	let retiraEnSucursal: String
	let subTotal: Double
	let sucursal: Sucursal
	let total: Double
	let totalExonerado, transporte: Double
	let version: String
	let direccion: Direccion?

	enum CodingKeys: String, CodingKey {
		case aNombreDe = "ANombreDe"
		case codMarca = "CodMarca"
		case codSegmento = "CodSegmento"
		case comentarios = "Comentarios"
		case descuento = "Descuento"
		case dispositivoID = "DispositivoId"
		case fechaHoraEntrega = "FechaHoraEntrega"
		case fechaHoraRetirar = "FechaHoraRetirar"
		case identificacion = "Identificacion"
		case impuesto = "Impuesto"
		case os = "OS"
		case pagos = "Pagos"
		case plataforma = "Plataforma"
		case productos = "Productos"
		case retiraEnSucursal = "RetiraEnSucursal"
		case subTotal = "SubTotal"
		case sucursal = "Sucursal"
		case total = "Total"
		case totalExonerado = "TotalExonerado"
		case transporte = "Transporte"
		case version = "Version"
		case direccion = "Direccion"
	}
}

struct Direccion: Codable {
	let codDireccion: Int
	let tipoDireccion, nombre, direccion, telefono: String
	let departamento, ciudad, referencia, latitud: String
	let longitud, direccionGps: String
	let kilometros, valorTransporte: Double
	let predeterminada: Int

	enum CodingKeys: String, CodingKey {
		case codDireccion = "CodDireccion"
		case tipoDireccion = "TipoDireccion"
		case nombre = "Nombre"
		case direccion = "Direccion"
		case telefono = "Telefono"
		case departamento = "Departamento"
		case ciudad = "Ciudad"
		case referencia = "Referencia"
		case latitud = "Latitud"
		case longitud = "Longitud"
		case direccionGps = "DireccionGps"
		case kilometros = "Kilometros"
		case valorTransporte = "ValorTransporte"
		case predeterminada = "Predeterminada"
	}
}


// MARK: - Pago

struct Pago: Codable {
	let aplicacionCupon: String
	let cambio: Double
	let codTarjeta: Int
	let codTipoPago, codigoBanco, descripcion: String
	let indiceFila: Int
	let monto: Double
	let numeroCupon: String
	let pago, valorCupon: Double

	enum CodingKeys: String, CodingKey {
		case aplicacionCupon = "AplicacionCupon"
		case cambio = "Cambio"
		case codTarjeta = "CodTarjeta"
		case codTipoPago = "CodTipoPago"
		case codigoBanco = "CodigoBanco"
		case descripcion = "Descripcion"
		case indiceFila = "IndiceFila"
		case monto = "Monto"
		case numeroCupon = "NumeroCupon"
		case pago = "Pago"
		case valorCupon = "ValorCupon"
	}
}

// MARK: - TipoPago

struct TipoPago: Codable {
	let codTipoPago, descripcion, codigoBanco, activo: String
	let orden: Int

	enum CodingKeys: String, CodingKey {
		case codTipoPago = "CodTipoPago"
		case descripcion = "Descripcion"
		case codigoBanco = "CodigoBanco"
		case activo = "Activo"
		case orden = "Orden"
	}
}


// MARK: - Producto

struct Producto: Codable {
	let indiceFila, porcentajeDescuento: Int
	let aplicaDescuento, aplicaIva: String
	var cantidad: Int
	let codCategoria, codProducto, codigoReferenciaProducto, descripcion: String
	let descuento: Double
	let impuesto: Double
	let notas: String
	let opciones: [Opcion]
	var precio, subTotal: Double
	var totalLinea: Double
	let descriptivos: String
	let foto: String? // esta imagen no deberia ir al api
	let codEmpresa: String? // este campo deberia ir al api
	
	/// Cadena descriptiva con opciones seleccionadas, sirve para saber si se debe fusionar un producto o agregar como nuevo item
	/// ༼ つ  ͡° ͜ʖ ͡° ༽つ
	///-----------------------
	var resumen: String {
		opciones
			.map({ $0.descripcion.lowercased() })
			.sorted()
			.joined(separator: ", ")
	}

	enum CodingKeys: String, CodingKey {
		case indiceFila = "IndiceFila"
		case porcentajeDescuento = "PorcentajeDescuento"
		case aplicaDescuento = "AplicaDescuento"
		case aplicaIva = "AplicaIva"
		case cantidad = "Cantidad"
		case codCategoria = "CodCategoria"
		case codProducto = "CodProducto"
		case codigoReferenciaProducto = "CodigoReferenciaProducto"
		case descripcion = "Descripcion"
		case descuento = "Descuento"
		case impuesto = "Impuesto"
		case notas = "Notas"
		case opciones = "Opciones"
		case precio = "Precio"
		case subTotal = "SubTotal"
		case totalLinea = "TotalLinea"
		case descriptivos = "Descriptivos"
		case foto
		case codEmpresa
	}
}

extension Array where Element == Producto {
	
	func getSubtotal() -> Double {
		reduce(0, { $0 + $1.subTotal })
	}
}

// MARK: - Opcion

struct Opcion: Codable {
	let aplicaDescuento, aplicaIva, codMenuRelacionado, codModificador: String
	let codOpcion, codTipoModificador, codigoReferencia, descripcion: String
	let id, idCarritoItem, orden: Int
	let precioOpcion: Double

	enum CodingKeys: String, CodingKey {
		case aplicaDescuento = "AplicaDescuento"
		case aplicaIva = "AplicaIva"
		case codMenuRelacionado = "CodMenuRelacionado"
		case codModificador = "CodModificador"
		case codOpcion = "CodOpcion"
		case codTipoModificador = "CodTipoModificador"
		case codigoReferencia = "CodigoReferencia"
		case descripcion = "Descripcion"
		case id = "Id"
		case idCarritoItem = "IdCarritoItem"
		case orden = "Orden"
		case precioOpcion = "PrecioOpcion"
	}
}

// MARK: - Sucursal

struct Sucursal: Codable {
	var coberturaKM, codEmpresa, codSucursal, departamento: String
	var diasAtencion, eslogan, horaApertura, horaCierre: String
	var idSucursal: Int
	var latitud, longitud, nombre: String
	var seleccionado: Bool
	var validaDiasAtencion, validaHoraApertura, validaHoraCierre: String

	enum CodingKeys: String, CodingKey {
		case coberturaKM = "CoberturaKm"
		case codEmpresa = "CodEmpresa"
		case codSucursal = "CodSucursal"
		case departamento = "Departamento"
		case diasAtencion = "DiasAtencion"
		case eslogan = "Eslogan"
		case horaApertura = "HoraApertura"
		case horaCierre = "HoraCierre"
		case idSucursal = "IdSucursal"
		case latitud = "Latitud"
		case longitud = "Longitud"
		case nombre = "Nombre"
		case seleccionado
		case validaDiasAtencion = "ValidaDiasAtencion"
		case validaHoraApertura = "ValidaHoraApertura"
		case validaHoraCierre = "ValidaHoraCierre"
	}
}

struct OrderResponse: Codable {
	let serie: String?
	let order: Int?
	let traking: String?
	let innerMessage: String?
}
