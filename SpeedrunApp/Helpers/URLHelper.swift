//
//  URLHelper.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 11/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import UIKit

extension URL {
	func getYoutubeURL() -> URL? {
		if let youtubeID = URLComponents(string: self.absoluteString)?.queryItems?
			.first(where: { $0.name == "v" })?.value {
			let appURL = URL(string: "youtube://www.youtube.com/watch?v=\(youtubeID)")!
			let application = UIApplication.shared

			if application.canOpenURL(appURL as URL) {
				return appURL
			}
		}
		return nil
	}

	func handleVideoURL() {
		let urlToOpen : URL = self.getYoutubeURL() != nil ? self.getYoutubeURL()! : self
		if UIApplication.shared.canOpenURL(urlToOpen) {
				UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
		}
	}
}
