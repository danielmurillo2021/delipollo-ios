//
//  SceneDelegate.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit

// swiftlint:disable all
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		
		var controller: UIViewController!
		
		if let token = Session.shared.getUserToken() {
			#if DEBUG
			print("user token: \(token)")
			#endif
			controller = DPNavigationController.loadFromStoryboard()
		} else {
//			if !UserDefaults.standard.bool(forKey: kDidShowOnboarding) {
//				controller = OnboardingController.loadFromStoryboard()
//			} else {
				controller = IntroController.loadFromStoryboard()
//			}
		}
		
		window.rootViewController = controller
		
		self.window = window
		
		window.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		
	}

	func sceneWillResignActive(_ scene: UIScene) {
		CartManager.shared.save()
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		CartManager.shared.start()
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		CartManager.shared.save()
	}

}
