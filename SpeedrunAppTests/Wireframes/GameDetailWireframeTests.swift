//
//  GameDetailWireframeTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import SpeedrunApp

class GameDetailWireframeTests: QuickSpec {

	override func spec() {
		describe("init") {
			let (_, wireframe) = createWireframe()

			it("creates the view and sets it as wireframes viewController") {
				guard
					let viewController = wireframe.viewController
						as? GameDetailViewController
					else { fail();	return }
				expect(viewController).to(be(wireframe.viewController))
			}
		}
	}

	func createWireframe() -> (Navigation, GameDetailWireframe) {
		let navigation = Navigation(window: UIWindow (frame: CGRect.zero))
		let wireframe = GameDetailWireframe(
			navigation: navigation,
			game: GameFactory.game()
		)

		try! wireframe.setAsRootWireframe(inNavigation: true)

		return (navigation, wireframe)
	}
}
