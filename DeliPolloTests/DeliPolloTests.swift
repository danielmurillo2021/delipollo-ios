//
//  DeliPolloTests.swift
//  DeliPolloTests
//
//  Created by Daniel Murillo on 19/12/20.
//

import XCTest
@testable import DeliPollo

class DeliPolloTests: XCTestCase {
	
	var repository: Repository!

	override func setUp() {
		repository = Repository()
	}
	
	override func tearDown() {
		repository = nil
	}

    func testLogin() throws {
        let promise = expectation(description: "Login succeed")
		
		repository.login(phone: "50581162325", code: "1234", completion: { result in
			switch result {
			case .success(let response):
				if let data = response.data {
					assert(data.token.count > 0)
					promise.fulfill()
				} else {
					XCTFail("failed to login: no data found")
				}
			case .failure(let error):
				XCTFail("failed to login: \(error.localizedDescription)")
			}
		})
		
		wait(for: [promise], timeout: 5)
    }
	
	func testSignin() throws {
		let promise = expectation(description: "Sigin succeed")
		
		repository.signin(phone: "50581160216", completion: { result in
			switch result {
			case .success(let response):
				if let data = response.data {
					assert(data.token.count > 0)
					promise.fulfill()
				} else {
					XCTFail("failed to login: no data found")
				}
			case .failure(let error):
				XCTFail("failed to login: \(error.localizedDescription)")
			}
		})
		
		wait(for: [promise], timeout: 5)
	}

}
