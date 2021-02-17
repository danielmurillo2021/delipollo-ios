//
//  RatingView.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 11/8/20.
//  Copyright © 2020 Daniel Murrillo. All rights reserved.
//

import UIKit

// swiftlint:disable all
public class RatingView: UIView {
	
	/// The total number of stars in the view. Default value is 5
	@IBInspectable public var numberOfStars: Int = 5 {
		didSet {
			var arr = [UIImageView]()
			for _ in 0..<numberOfStars {
				arr.append(initialStarImageView)
			}
			starsStackView.subviews.forEach({ $0.removeFromSuperview() })
			imageViews.removeAll()
			imageViews.append(contentsOf: arr)
			imageViews.forEach({ starsStackView.addArrangedSubview($0) })
		}
	}
	
	/// Set the current rating, default is 5.
	public var currentRating = 5 {
		didSet {
			updateCurrentStars(oldValue: oldValue)
		}
	}
	
	/// Indicates if a haptic feedback should be generated when tapping a star. Default is true
	@IBInspectable public var generateHapticFeedbackOnSelection: Bool = true
	
	/// Private: The selected rating,
	private(set) var selectedRating: Int = 5 {
		didSet {
			if selectedRating != oldValue {
				if generateHapticFeedbackOnSelection {
					UISelectionFeedbackGenerator().selectionChanged()
				}
				didChangeSelection?(selectedRating)
			}
		}
	}
	
	/// The color of the star
	@IBInspectable public var starColor: UIColor? {
		didSet {
			imageViews.forEach({ $0.tintColor = starColor })
		}
	}
	
	/// Closure indicating that the selection did change, returns the value of the selection
	public var didChangeSelection: ((Int) -> Void)?
	
	/// Used to adjust the spacing distance between stars
	@IBInspectable public var starsSpacing: NSNumber? {
		didSet {
			starsStackView.spacing = CGFloat(starsSpacing!.floatValue)
		}
	}
	
	/// StackView that holds imageviews
	private let starsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		stackView.alignment = .center
		return stackView
	}()
	
	/// Image view initiated with stars images
	private var initialStarImageView: UIImageView {
		let imageView = UIImageView()
		imageView.image = filledImage
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		imageView.isUserInteractionEnabled = true
		return imageView
	}
	
	/// The image of the filled star
	private var filledImage: UIImage {
		UIImage(systemName: "star.fill")!
	}
	
	/// The image of the empty star
	private var emptyImage: UIImage {
		UIImage(systemName: "star")!
	}
	
	/// Initial image views
	private lazy var imageViews: [UIImageView] = {
		var imagesArray = [UIImageView]()
		for i in 0..<numberOfStars {
			let starImageView = initialStarImageView
			starImageView.tag = i + 1
			starImageView.addTapGesture(handler: { gesture in
				if let owner = gesture.view {
					#if DEBUG
					print("selected star: \(owner.tag)")
					#endif
					self.currentRating = owner.tag
				}
			})
			imagesArray.append(starImageView)
		}
		return imagesArray
	}()
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	private func setup() {
		setupStackView()
	}
	
	private func setupStackView() {
		addSubview(starsStackView)
		NSLayoutConstraint.activate([
			starsStackView.topAnchor.constraint(equalTo: self.topAnchor),
			starsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			starsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			starsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
		imageViews.forEach({ starsStackView.addArrangedSubview($0) })
	}
}

// MARK: - Events methods

extension RatingView {
	
	override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
//		handleTouches(touches)
	}
	
	override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
//		handleTouches(touches)
	}
	
//	private func handleTouches(_ touches: Set<UITouch>) {
//		guard let firstTouch = touches.first else { return }
//
//		let location = firstTouch.location(in: starsStackView)
//
//		imageViews.forEach {
//			if $0.frame.contains(location) {
//				guard let index = imageViews.firstIndex(of: $0) else { return }
//
//				imageViews.forEach({ $0.image = emptyImage })
//
//				for i in 0...index {
//					imageViews[i].image = filledImage
//				}
//				selectedRating = index + 1
//			}
//		}
//	}
	
	private func updateCurrentStars(oldValue: Int) {
		guard currentRating >= 1, currentRating <= numberOfStars else {
			currentRating = oldValue
			return
		}
		
		imageViews.forEach({ $0.image = emptyImage })
		
		for i in 0..<currentRating {
			imageViews[i].image = filledImage
		}
	}
}
