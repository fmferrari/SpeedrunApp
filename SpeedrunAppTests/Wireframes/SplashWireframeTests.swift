//
//  SplashWireframeTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import SpeedrunApp

class SplashWireframeTests: QuickSpec {

	override func spec() {
		describe("init") {
			let (_, wireframe) = createWireframe()

			it("creates the view with the eventsHandler") {
				guard
					let viewController = wireframe.viewController
						as? SplashViewController
					else { fail();	return }
				expect(viewController.eventsHandler).to(be(wireframe.splashEventsHandler))
			}

			it("sets the wireframe as viewControllers wireframe") {
				guard
					let viewController = wireframe.viewController
						as? SplashViewController
					else { fail();	return }
				expect(viewController.wireframe).to(be(wireframe))
			}
		}
	}

	func createWireframe() -> (Navigation, SplashWireframe) {
		let navigation = Navigation(window: UIWindow (frame: CGRect.zero))
		let wireframe = SplashWireframe(navigation: navigation)

		try! wireframe.setAsRootWireframe(inNavigation: true)

		return (navigation, wireframe)
	}
}

