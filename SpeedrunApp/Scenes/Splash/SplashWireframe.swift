//
//  SplashWireframe.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit

protocol SplashNavigation: class {
	func presentHome( for state: AppState )
	func presentInformationPopup(
		title: String?,
		message: String,
		animated: Bool,
		action: (() -> Void)?
	)
}

class SplashWireframe: Wireframe {
	let splashEventsHandler: SplashEventsHandler

	required init(navigation: Navigation) {
		self.splashEventsHandler = SplashEventsHandler (
			fetchSpeedruns: FetchSpeedrunsInteractor.withDefaultApi
		)

		let splashView = SplashViewController()

		super.init(navigation: navigation)

		self.viewController = splashView
		splashView.eventsHandler = splashEventsHandler
		self.splashEventsHandler.navigation = self
	}
}

extension SplashWireframe: SplashNavigation {
	public func presentHome (for state: AppState) {

	}
}
