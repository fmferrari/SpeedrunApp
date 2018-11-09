//
//  AppStyle.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit

struct AppStyle {
	struct Colors {
		let foreground : UIColor
		let background: UIColor
	}

	struct Fonts {
		let futura : UIFont
	}

	let colors: Colors
	let fonts: Fonts
}

extension AppStyle {
	static let `default`: AppStyle = AppStyle(
		colors: AppStyle.Colors(
			foreground: #colorLiteral(red: 0.3978005052, green: 0.3978720903, blue: 0.3977910876, alpha: 1),
			background: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		),
		fonts: AppStyle.Fonts(
			futura: UIFont(name: "Futura", size: 21)!
		)
	)
}
