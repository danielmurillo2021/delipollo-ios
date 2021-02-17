//
// PC GROUP SA
// DeliPollo - PointsController.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 21/1/21
// Copyright © 2021. All rights reserved.

import UIKit

class PointsController: DPViewController, StoryboardLoadable {
	static var storyboardId: String = "PointsController"
	static var storyboardName: String = "Points"
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var accountButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		accountButton.onTap {
			self.mainNavigationController.set(screen: .menu)
		}
		
		searchButton.onTap {
			self.mainNavigationController.set(screen: .search)
		}
		
		backButton.onTap {
			self.mainNavigationController.navigateBack()
		}
		
		mainNavigationController.showPlaceholder("¡todavía no hay puntos!")
	}
}
