//
//  DPViewController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 19/12/20.
//

import UIKit

class DPViewController: UIViewController {
	
	var mainNavigationController: DPNavigationController!
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if mainNavigationController != nil {
			mainNavigationController.hidePlaceholder()
		}
		
		view.addTapGesture(handler: { _ in
			self.view.endEditing(true)
		})
	}
}
