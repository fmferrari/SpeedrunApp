//
//  SplashWireframe.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit

protocol SplashNavigation: class {

}

class SplashWireframe: Wireframe {
	let splashEventsHandler: SplashEventsHandler

	required init(navigation: Navigation) {
		self.splashEventsHandler = SplashEventsHandler ()

		let splashView = SplashViewController()

		super.init(navigation: navigation)

		self.viewController = splashView
		splashView.eventsHandler = splashEventsHandler
		self.splashEventsHandler.navigation = self
	}
}

extension SplashWireframe: SplashNavigation {

}
