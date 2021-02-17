//
//  InductionController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 3/1/21.
//

import UIKit

class InductionController: UIViewController, StoryboardLoadable {
	
	static var storyboardId: String = "InductionController"
	static var storyboardName: String = "Onboarding"

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var nextButton: UIButton!
	
	weak var pageViewController: OnboardingController!
	
	var induction: Induction!
	var currentIndex: Int!
	var pageCount: Int!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareUI() {
		
		if let induction = induction {
			titleLabel.text = induction.title
			subtitleLabel.text = induction.subtitle
		}
		
		pageControl.numberOfPages = pageCount
		pageControl.currentPage = currentIndex
		
		if currentIndex == 0 {
			nextButton.setTitle("saltar", for: .normal)
		}
		
		nextButton.onTap {
			if self.currentIndex == self.pageCount - 1 {
				self.navigateToIntro()
			} else {
				self.pageViewController.changePage(to: self.currentIndex + 1)
			}
		}
		
	}
	
	private func navigateToIntro() {
		UserDefaults.standard.set(true, forKey: kDidShowOnboarding)
		let controller = IntroController.loadFromStoryboard()
		controller.modalPresentationStyle = .overFullScreen
		present(controller, animated: true, completion: nil)
	}
}
