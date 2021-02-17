//
// PC GROUP SA
// DeliPollo - MustLoginController.swift
// Created by Daniel Murillo - daniel@fsln.com
// Created on 22/1/21
// Copyright © 2021. All rights reserved.

import UIKit

class MustLoginController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "MustLoginController"
	static var storyboardName: String = "Navigation"
	
	@IBOutlet weak var enterButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var containerView: UIView!
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(named: "loloBlue")?.withAlphaComponent(0.7)
		containerView.backgroundColor = UIColor.white
		
		enterButton.onTap {
			IntroController.loadAsync(completion: {
				self.present($0, animated: true, completion: nil)
			})
		}
		
		cancelButton.onTap {
			self.dismiss(animated: true, completion: nil)
		}
	}
}
