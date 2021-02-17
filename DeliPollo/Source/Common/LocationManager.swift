//
//  LocationManager.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 30/12/20.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
	
	var locationManager: CLLocationManager?
	var lastLocation: CLLocation?
	
	static var shared = LocationManager()
	
	private override init() {
		super.init()
		locationManager = CLLocationManager()
		locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		locationManager?.distanceFilter = 20
		locationManager?.delegate = self
	}
	
	func start() {
		startUpdatingLocation()
	}
	
	private func startUpdatingLocation() {
		if CLLocationManager.authorizationStatus() == .notDetermined {
			locationManager?.requestWhenInUseAuthorization()
		}
		self.locationManager?.startUpdatingLocation()
	}
	
	private func stopUpdatingLocation() {
		self.locationManager?.stopUpdatingLocation()
	}
	
	func isLocationSettingsEnabled() -> Bool {
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined, .restricted, .denied:
				return false
			case .authorizedAlways, .authorizedWhenInUse:
				return true
			default:
				break
			}
		}
		
		return false
	}
	
	func getLocationInformation(latitude: Double, longitude: Double, completion: @escaping ((String, String)?) -> Void) {
		let location = CLLocation(latitude: latitude, longitude: longitude)
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
			if error == nil {
				if let firstLocation = placemarks?.first,
				   let city = firstLocation.locality,
				   let department = firstLocation.administrativeArea {
					completion((city, department))
				}
			} else {
				completion(nil)
			}
		})
	}
}

extension LocationManager: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		print("did set last location at: \(location)")
		self.lastLocation = location
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		
	}
}
