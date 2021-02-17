//
//  CollectionLayouts.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 2/1/21.
//

import UIKit

struct CollectionLayouts {
	
	static var horizontalCategories: NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
		item.contentInsets.trailing = 4
		item.contentInsets.leading = 4
		item.contentInsets.bottom = 4
		item.contentInsets.top = 4
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(150)), subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		return section
	}
	
	static var grid: NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(200)))
		item.contentInsets.top = 4
		item.contentInsets.bottom = 4
		item.contentInsets.trailing = 4
		item.contentInsets.leading = 4
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)), subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .none
		return section
	}
	
	static var productsList: NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)))
		item.contentInsets.trailing = 0
		item.contentInsets.bottom = 0
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)), subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets.leading = 0
		
		return section
	}
	
	static var horizontalProductsList: NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(260)))
		item.contentInsets.top = 4
		item.contentInsets.bottom = 4
		item.contentInsets.trailing = 4
		item.contentInsets.leading = 4
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(260)), subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		return section
	}
	
	static func fullWidth(height: CGFloat = 400) -> NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)))
		item.contentInsets.trailing = 4
		item.contentInsets.leading = 4
		item.contentInsets.bottom = 4
		item.contentInsets.top = 4
		
		let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)), subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .none
		return section
	}
	
	static func productModifier() -> NSCollectionLayoutSection {
		let height: CGFloat = 60
		
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(height)))
		item.contentInsets.top = 4
		item.contentInsets.bottom = 4
		item.contentInsets.trailing = 4
		item.contentInsets.leading = 4
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height)), subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .none
		
		let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																  heightDimension: .absolute(50.0))
		let header = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: headerSize,
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment: .top)

		section.boundarySupplementaryItems = [header]
		
		return section
	}
}
