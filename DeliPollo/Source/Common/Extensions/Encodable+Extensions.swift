//
//  Encodable+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 10/16/20.
//  Copyright © 2020 Daniel Murrillo. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: AnyObject]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
			.flatMap { $0 as? [String: AnyObject] }
    }
	
	var data: Data? {
		return try? JSONEncoder().encode(self)
	}
}
