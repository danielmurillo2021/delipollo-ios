//
//  AppDelegate.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit
import Bagel
import IQKeyboardManagerSwift
import GoogleMaps
import Toaster

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		start()
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		
	}
	
	private func start() {
		#if DEBUG
		Bagel.start()
		RealmManager.shared.getRealmRouteFile()
		#endif
		GMSServices.provideAPIKey(kGoogleMaps)
		CartManager.shared.start()
		
		ToastView.appearance().bottomOffsetPortrait = 100
		ToastView.appearance().backgroundColor = .loloYellow
		ToastView.appearance().tintColor = .white
	}
}
