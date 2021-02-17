//
//  StoryboardLoadable.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit

protocol StoryboardLoadable: UIViewController {
	static var storyboardId: String { get }
	static var storyboardName: String { get }
}

// swiftlint:disable force_cast

extension StoryboardLoadable {
	
	static func loadFromStoryboard() -> Self {
		return UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: storyboardId) as! Self
	}
	
	static func loadAsync(completion: @escaping (Self) -> Void) {
		DispatchQueue.main.async {
			let controller = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: storyboardId) as! Self
			controller.modalPresentationStyle = .overFullScreen
			completion(controller)
		}
	}
}
