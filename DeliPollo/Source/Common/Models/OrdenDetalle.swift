//
// PC GROUP SA
// DeliPollo - OrdenDetalle.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 12/1/21
// Copyright © 2021. All rights reserved.

import Foundation

struct DetalleOrden: Codable {
	let codOrden: Int
	let codMarca, codEmpresa, codSucursal, fechaOrden: String
	let horaOrden, fechaRetiro, horaRetiro, nombrede: String
	let tipoPago: String
	let codTarjeta: Int
	let pago: Double
	let cambio: Double
	let retiraEnSucursal, direccionDesc: String
	let subTotal: Double
	let descuento: Double
	let iva: Double
	let valTrans: Double
	let totalPago: Double
	let tieneCupon, numeroCupon: String
	let montoCupon: Double
	let codEstado: Int
	let decripcionEstado: String
	let productos: [DetalleOrdenProducto]
	let sucursal: DetalleOrdenSucursal?
	let direccion: DetalleOrdenDireccion?
	let tarjeta: DetalleOrdenTarjeta?
	let observaciones, latitud, longitud, estaValorada: String

	enum CodingKeys: String, CodingKey {
		case codOrden = "CodOrden"
		case codMarca = "CodMarca"
		case codEmpresa = "CodEmpresa"
		case codSucursal = "CodSucursal"
		case fechaOrden = "FechaOrden"
		case horaOrden = "HoraOrden"
		case fechaRetiro = "FechaRetiro"
		case horaRetiro = "HoraRetiro"
		case nombrede = "Nombrede"
		case tipoPago = "TipoPago"
		case codTarjeta = "CodTarjeta"
		case pago = "Pago"
		case cambio = "Cambio"
		case retiraEnSucursal = "RetiraEnSucursal"
		case direccionDesc = "DireccionDesc"
		case subTotal = "SubTotal"
		case descuento = "Descuento"
		case iva = "Iva"
		case valTrans = "Val_Trans"
		case totalPago = "TotalPago"
		case tieneCupon = "TieneCupon"
		case numeroCupon = "NumeroCupon"
		case montoCupon = "MontoCupon"
		case codEstado = "CodEstado"
		case decripcionEstado = "DecripcionEstado"
		case productos = "Productos"
		case sucursal = "Sucursal"
		case direccion = "Direccion"
		case tarjeta = "Tarjeta"
		case observaciones = "Observaciones"
		case latitud = "Latitud"
		case longitud = "Longitud"
		case estaValorada = "EstaValorada"
	}
}

// MARK: - Producto

struct DetalleOrdenProducto: Codable {
	let codProducto, descripcion: String
	let cantidad: Int
	let precio: Double
	let totalLinea: Double
	let descriptivos: String
	let urlImg, urlImg2: String
	let urlImg3: String

	enum CodingKeys: String, CodingKey {
		case codProducto = "CodProducto"
		case descripcion = "Descripcion"
		case cantidad = "Cantidad"
		case precio = "Precio"
		case totalLinea = "TotalLinea"
		case descriptivos = "Descriptivos"
		case urlImg = "UrlImg"
		case urlImg2 = "UrlImg2"
		case urlImg3 = "UrlImg3"
	}
}

// MARK: - Sucursal

struct DetalleOrdenSucursal: Codable {
	let codEmpresa, codSucursal, nombre, direccion: String

	enum CodingKeys: String, CodingKey {
		case codEmpresa = "CodEmpresa"
		case codSucursal = "CodSucursal"
		case nombre = "Nombre"
		case direccion = "Direccion"
	}
}

// MARK: - DetalleOrdenDireccion

struct DetalleOrdenDireccion: Codable {
	let predeterminada: Int
	let direccion, telefono: String
	let codDireccion: Int
	let ciudad: String
	let kilometros, valorTransporte: Double
	let latitud, direccionGps, longitud, nombre: String
	let departamento, referencia, tipoDireccion: String

	enum CodingKeys: String, CodingKey {
		case predeterminada = "Predeterminada"
		case direccion = "Direccion"
		case telefono = "Telefono"
		case codDireccion = "CodDireccion"
		case ciudad = "Ciudad"
		case kilometros = "Kilometros"
		case valorTransporte = "ValorTransporte"
		case latitud = "Latitud"
		case direccionGps = "DireccionGps"
		case longitud = "Longitud"
		case nombre = "Nombre"
		case departamento = "Departamento"
		case referencia = "Referencia"
		case tipoDireccion = "TipoDireccion"
	}
}

// MARK: - DetalleOrdenTarjeta

struct DetalleOrdenTarjeta: Codable {
	let nombre, numero, cvv: String
	let predeterminada, codTarjeta: Int
	let fechaExpira, tipoBanco: String

	enum CodingKeys: String, CodingKey {
		case nombre = "Nombre"
		case numero = "Numero"
		case cvv = "Cvv"
		case predeterminada = "Predeterminada"
		case codTarjeta = "CodTarjeta"
		case fechaExpira = "FechaExpira"
		case tipoBanco = "TipoBanco"
	}
}

// MARK: - InsertarValoracion

struct InsertarValoracion: Codable {
	let codOrden: Int
	let valoraciones: [Valoracion]

	enum CodingKeys: String, CodingKey {
		case codOrden = "CodOrden"
		case valoraciones = "Valoraciones"
	}
}

// MARK: - Valoracione
struct Valoracion: Codable {
	var codPregunta, valor: Int
	var comentarios: String

	enum CodingKeys: String, CodingKey {
		case codPregunta = "CodPregunta"
		case valor = "Valor"
		case comentarios = "Comentarios"
	}
}
