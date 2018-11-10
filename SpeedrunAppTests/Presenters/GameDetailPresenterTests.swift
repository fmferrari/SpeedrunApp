//
//  GameDetailPresenterTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift

@testable import SpeedrunApp

class GameDetailPresenterTests: QuickSpec {

	override func spec() {

		context("when the presenter is created") {
			let (presenter, view) = createPresenter()

			context("when subscribeToViewEvents is called") {
				beforeEach {
					presenter.subscribeToViewEvents()
				}
				it("sets the game information to the view") {
					expect(view.setGameInformationWasCalled).to(beTrue())
				}
			}
		}

	}

	func createPresenter() ->
		(
		GameDetailPresenter, GameDetailViewMock
		) {
			let view = GameDetailViewMock()
			let presenter = GameDetailPresenter(
				game:GameFactory.game(),
				view: view
			)

			return (presenter, view)
	}
}

// MARK: Mocks
class GameDetailViewMock: GameDetailView {
	var setGameInformationWasCalled = false
	func setGameInformation(_ game: GameToDisplay) {
		setGameInformationWasCalled = true
	}
}

