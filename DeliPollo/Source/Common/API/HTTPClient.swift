//
//  HTTPClient.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 22/12/20.
//

import Foundation
import Reachability

typealias HTTPBody = [String: AnyObject]

// swiftlint:disable all

final class HTTPClient {
	
	private let realmManager: RealmManager
	private let urlSession: URLSession
	private let token: String
	private let url: String
	
	init(realmManager: RealmManager = RealmManager.shared, urlSession: URLSession = .shared, token: String = kServiceToken, url: String = kServiceURL) {
		self.realmManager = realmManager
		self.urlSession = urlSession
		self.token = token
		self.url = url
	}
}

extension HTTPClient {
	
	private func fetch<E: Codable>(path: String,
								   type: E.Type,
								   body: HTTPBody? = nil,
								   method: HTTPMethod = .get,
								   cache: String? = nil,
								   forceToken: Bool = false,
								   contentType: ContentType = .json,
								   completion: @escaping (Result<E, APIError>) -> Void) {
		
		let requestUrl = URL(string: url.appending(path))!
		var request = URLRequest(url: requestUrl)
		request.httpMethod = method.rawValue
		request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
		request.timeoutInterval = 90.0
		
		if let userToken = Session.shared.getUserToken(), !forceToken {
			request.setValue("Bearer ".appending(userToken), forHTTPHeaderField: "authorization")
		} else {
			request.setValue("Bearer ".appending(token), forHTTPHeaderField: "authorization")
		}
		
		if method == .post || method == .put, let body = body {
			if contentType == .json {
				do {
					let httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
					request.httpBody = httpBody
				} catch {
					completion(.failure(.serialization))
					return
				}
			} else if contentType == .urlEncoded {
				let query = body.map { "\($0)=\($1)" }.joined(separator: "&")
				request.httpBody = query.data(using: .utf8)
			}
		}
		
		let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
			
			if let response = response as? HTTPURLResponse {
				
				switch response.statusCode {
				case 200..<300:
					
					#if DEBUG
					print("🔥 API \(method.rawValue) ---> \(path)")
					#endif
					
					guard let data = data else {
						completion(.failure(.unknown("Ocurrió un error")))
						return
					}
					
					if let cache = cache {
						let object = Cache()
						object.id = cache
						object.data = data
						self.realmManager.set(object)
					}
					
					do {
						let decodedResponse = try JSONDecoder().decode(type, from: data)
						completion(.success(decodedResponse))
					} catch let DecodingError.dataCorrupted(context) {
						print(context)
					} catch let DecodingError.keyNotFound(key, context) {
						print("🐛 Key '\(key)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch let DecodingError.valueNotFound(value, context) {
						print("🐛 Value '\(value)' not found:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch let DecodingError.typeMismatch(type, context)  {
						print("🐛 Type '\(type)' mismatch:", context.debugDescription)
						print("codingPath:", context.codingPath)
					} catch {
						completion(.failure(.serialization))
					}
					
				case 400, 404:
					if let data = data {
						do {
							let decodedResponse = try JSONDecoder().decode(type, from: data)
							completion(.success(decodedResponse))
						} catch {
							completion(.failure(.notFound))
						}
					} else {
						completion(.failure(.notFound))
					}
					
				case 401..<403:
					completion(.failure(.forbidden))
					
				default:
					completion(.failure(.unknown(kErrorOcurred)))
				}
			}
			
			if let error = error {
				completion(.failure(.unknown(error.localizedDescription)))
			}
		})
		
		task.resume()
	}
	
	func get<E: Codable>(path: String,
						 type: E.Type,
						 completion: @escaping (Result<E, APIError>) -> Void) {
		
		let reachability = try? Reachability()
		
		switch reachability?.connection {
		case .unavailable:
			completion(.failure(.internetConnection))
		default:
			fetch(path: path, type: type, method: .get, completion: completion)
		}
		
	}
	
	func get<E: Codable>(path: String,
						 type: E.Type,
						 cache: ((E) -> Void),
						 completion: @escaping (Result<E, APIError>) -> Void) {
		
		let reachability = try? Reachability()
		
		if let objects = realmManager.getFromCache(path, type: type) {
			#if DEBUG
			print("❄️ CACHE ---> \(path)")
			#endif
			cache(objects)
		}
		
		switch reachability?.connection {
		case .unavailable:
			completion(.failure(.internetConnection))
			
		default:
			fetch(path: path, type: type, method: .get, cache: path, completion: completion)
		}
		
	}
	
	func post<E: Codable>(path: String,
						  body: HTTPBody,
						  type: E.Type,
						  contentType: ContentType = .json,
						  forceToken: Bool = false,
						  completion: @escaping (Result<E, APIError>) -> Void) {
		
		let reachability = try? Reachability()
		
		switch reachability?.connection {
		case .unavailable:
			completion(.failure(.internetConnection))
		default:
			fetch(path: path, type: type, body: body, method: .post, forceToken: forceToken, contentType: contentType, completion: completion)
		}
	}
}
