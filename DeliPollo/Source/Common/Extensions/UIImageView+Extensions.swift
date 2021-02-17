//
//  UIImageView+Extensions.swift
//  DeliPollo
//
//  Created by Daniel Murillo on 10/14/20.
//  Copyright © 2020 Daniel Murrillo. All rights reserved.
//

import UIKit
import Kingfisher

enum StorageType {
	case userDefaults
	case fileSystem
}

func filePath(forKey key: String, ext: String = ".png") -> URL? {
	let fileManager = FileManager.default
	guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
	return documentURL.appendingPathComponent(key + ext)
}

extension UIImage {
	
	func scalePreservingAspectRatio(targetSize: CGSize = CGSize(width: 60, height: 60)) -> UIImage {
		// Determine the scale factor that preserves aspect ratio
		let widthRatio = targetSize.width / size.width
		let heightRatio = targetSize.height / size.height
		
		let scaleFactor = min(widthRatio, heightRatio)
		
		// Compute the new image size that preserves aspect ratio
		let scaledImageSize = CGSize(
			width: size.width * scaleFactor,
			height: size.height * scaleFactor
		)

		// Draw and return the resized UIImage
		let renderer = UIGraphicsImageRenderer(
			size: scaledImageSize
		)

		let scaledImage = renderer.image { _ in
			self.draw(in: CGRect(
				origin: .zero,
				size: scaledImageSize
			))
		}
		
		return scaledImage
	}
	
	func convertImageToBase64String() -> String {
		self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? kEmptyString
	}
	
	func store(forKey key: String, withStorageType storageType: StorageType = .fileSystem) {
		if let pngRepresentation = self.pngData() {
			switch storageType {
			case .fileSystem:
				if let filePath = filePath(forKey: key) {
					do {
						try pngRepresentation.write(to: filePath, options: .atomic)
					} catch let err {
						print("Saving file resulted in error: ", err)
					}
				}
			case .userDefaults:
				UserDefaults.standard.set(pngRepresentation, forKey: key)
			}
		}
	}
	
	static func retrieveImage(forKey key: String, inStorageType storageType: StorageType = .fileSystem) -> UIImage? {
		switch storageType {
		case .fileSystem:
			if let filePath = filePath(forKey: key),
				let fileData = FileManager.default.contents(atPath: filePath.path),
				let image = UIImage(data: fileData) {
				return image
			}
		case .userDefaults:
			if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
				let image = UIImage(data: imageData) {
				return image
			}
		}
		return nil
	}
}

extension UIImageView {
	
	/// Set image by given URL
	/// - Parameters:
	///   - url: The url of image
	///   - border: Color of the border
	///   - contentMode: Content mode of image
	///   - placeholder: Placeholder name
	///   - replace: Indicates if should set image as nil before setting new image
	func setImage(_ url: String, border: String? = nil, contentMode: ContentMode = .scaleAspectFill, placeholder: String? = nil, replace: Bool = true) {
		
		if replace {
			self.image = nil
		}
		
		// add default border to the view (optional)
		if let border = border, border != kEmptyString {
			layer.borderWidth = 4
//			layer.borderColor = UIColor(hex: border).cgColor
			layer.cornerRadius = 8
		}
		
		// add placeholder
		if let placeholder = placeholder {
			self.image = UIImage(named: placeholder)
			self.contentMode = .scaleAspectFit
		}
		
		// set image by url
		if url != kEmptyString,
			let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			let url = URL(string: urlString) {
			
			self.contentMode = contentMode
			self.kf.setImage(with: url, completionHandler: { result in
				switch result {
				case .success:
					break
				case .failure:
					print("---> Error trying to fetch image: \(url)")
				}
			})
		}
	}
}
