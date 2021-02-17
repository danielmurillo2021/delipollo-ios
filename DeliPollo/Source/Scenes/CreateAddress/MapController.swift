//
//  MapController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 30/12/20.
//

import UIKit
import GoogleMaps

class MapController: DPViewController, StoryboardLoadable {
	
	static var storyboardId: String = "MapController"
	static var storyboardName: String = "Addresses"
	
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var locationButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	
	@IBOutlet weak var containerView: UIView!
	
	private var mapView: GMSMapView!
	private var selectedCoordinate: CLLocationCoordinate2D!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareMap() {
		let camera = GMSCameraPosition.camera(withLatitude: 12.1042873, longitude: -86.2655182, zoom: 15.0)
		let frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
		
		mapView = GMSMapView.map(withFrame: frame, camera: camera)
		mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		mapView.delegate = self
		
		do {
			if let styleURL = Bundle.main.url(forResource: "map_style", withExtension: "json") {
				mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
			} else {
				NSLog("Unable to find styles file")
			}
		} catch {
			NSLog("One or more of the map styles failed to load. \(error)")
		}

		containerView.insertSubview(mapView, at: 0)
		
		setCurrentLocation()
	}
	
	private func setCurrentLocation() {
		guard let location = LocationManager.shared.lastLocation else { return }
		
		let currentCamera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
		mapView.camera = currentCamera
		setCoordinate(location.coordinate)
	}
	
	private func prepareUI() {
		
		prepareMap()
		
		backButton.onTap {
			switch self.mainNavigationController.context {
			case .checkout:
				self.mainNavigationController.set(screen: .selectAddress)
			case .normal:
				self.mainNavigationController.set(screen: .addresses)
			}
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		locationButton.onTap {
			self.setCurrentLocation()
		}
		
		continueButton.onTap {
			guard let coordinate = self.selectedCoordinate else { return }
			
			self.mainNavigationController.set(screen: .createAddress(coordinate.latitude, coordinate.longitude))
		}
	}
	
	private func setCoordinate(_ coordinate: CLLocationCoordinate2D) {
		mapView.clear()
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
		marker.map = mapView
		marker.icon = UIImage(named: "ic_marker")
		selectedCoordinate = coordinate
	}
}

extension MapController: GMSMapViewDelegate {
	
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
		
	}
	
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		setCoordinate(coordinate)
	}
}
