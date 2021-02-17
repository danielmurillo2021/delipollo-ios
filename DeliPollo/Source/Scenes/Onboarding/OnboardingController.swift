//
//  OnboardingController.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 3/1/21.
//

import UIKit

class OnboardingController: UIPageViewController, StoryboardLoadable {
	
	static var storyboardId: String = "OnboardingController"
	static var storyboardName: String = "Onboarding"
	
	var orderedViewControllers: [UIViewController] = []
	
	deinit {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareUI()
	}
	
	private func prepareUI() {
		dataSource = self
		view.backgroundColor = .white

		let repository = Repository()
		
		repository.getInductions(cache: { cache in
			print(cache) // no usa cache en este view
		}, completion: { [weak self] result in
			switch result {
			case .success(let response):
				if let data = response.data {
					data.sorted(by: { $0.order < $1.order })
						.forEach({ item in
							InductionController.loadAsync(completion: { controller in
								controller.induction = item
								controller.pageViewController = self
								controller.currentIndex = item.order - 1
								controller.pageCount = data.count
								self?.orderedViewControllers.append(controller)
								
								if item.order == 1 {
									self?.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
								}
							})
						})
				}
			case .failure:
				IntroController.loadAsync(completion: {
					self?.present($0, animated: true, completion: nil)
				})
			}
		})
	}
	
	func changePage(to index: Int) {
		let currentIndex = presentationIndex(for: self)
		
		guard index != currentIndex else { return }
		
		setViewControllers([orderedViewControllers[index]],
						   direction: index < currentIndex ? .reverse : .forward,
						   animated: true,
						   completion: nil)
	}
	
	internal func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		   guard
			   let firstViewController = viewControllers?.first,
			   let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController)
			   else {
				   return 0
		   }
		   
		   return firstViewControllerIndex
	   }

}

extension OnboardingController: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
		
		let previousIndex = viewControllerIndex - 1
		
		guard previousIndex >= 0 else { return nil }
		
		guard orderedViewControllers.count > previousIndex else { return nil }
		
		return orderedViewControllers[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
		
		let nextIndex = viewControllerIndex + 1
		let orderedViewControllersCount = orderedViewControllers.count
		
		guard orderedViewControllersCount != nextIndex else { return nil }
		
		guard orderedViewControllersCount > nextIndex else { return nil }
		
		return orderedViewControllers[nextIndex]
	}
	
}
