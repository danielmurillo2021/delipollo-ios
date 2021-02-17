//
//  PromoSliderCell.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 10/15/20.
//  Copyright © 2020 Daniel Murrillo. All rights reserved.
//

import UIKit
import FSPagerView

class PromoSliderCell: UICollectionViewCell, NibLoadable {

	static var reuseIdentifier: String = "PromoSliderCell"
	
	static var nib: UINib {
		UINib(nibName: reuseIdentifier, bundle: nil)
	}
	
	var promotions: [Promotion] = [] {
		didSet {
			reload()
		}
	}
	
	@IBOutlet weak var pagerView: FSPagerView!
	@IBOutlet weak var pageControl: FSPageControl!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		pagerView.backgroundColor = .clear
		pagerView.itemSize = CGSize(width: frame.width * 0.80, height: (frame.height - 20) * 0.90)
		pagerView.interitemSpacing = 8
		pagerView.isInfinite = true
		pagerView.transformer = FSPagerViewTransformer(type: .linear)
		pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
		pagerView.dataSource = self
		pagerView.delegate = self
		
		pageControl.backgroundColor = .clear
		pageControl.hidesForSinglePage = true
		pageControl.setFillColor(.loloBlue, for: .normal)
		pageControl.setFillColor(.loloGray, for: .selected)
    }
	
	func reload() {
		pagerView.reloadData()
		pageControl.numberOfPages = promotions.count
		pageControl.currentPage = 0
	}

}

extension PromoSliderCell: FSPagerViewDataSource {
	
	func numberOfItems(in pagerView: FSPagerView) -> Int {
		promotions.count
	}
	
	func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
		let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
		cell.imageView?.setImage(promotions[index].image)
		return cell
	}
}

extension PromoSliderCell: FSPagerViewDelegate {
	
	func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}
