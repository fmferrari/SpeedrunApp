//
//  SplashEventsHandlerTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift

@testable import SpeedrunApp

class SplashEventsHandlerTests: QuickSpec {

	override func spec() {

		context("when the eventsHandler is created") {
			let (navigation, fetchGames, eventsHandler) = createEventsHandler()

			context("when the view is loaded") {
				beforeEach{ eventsHandler.viewDidLoad() }

				it ("calls the fetcher") {
					expect(fetchGames.executeWasCalled).to(beTrue())
				}

				context ("when the fetcher responds successfully") {
					beforeEach {
						fetchGames.gamesToReturnObserver.onNext([GameFactory.game()])
					}

					it ("tells navigation to present home with an app state containing fetched games") {
						expect (navigation.state?.gamesRepository.games.first?.id) == GameFactory.game().id
					}
				}

				context ("when the fetcher has an error") {
					beforeEach { fetchGames.gamesToReturnObserver.onError(NSError()) }

					it("shows the error popup") {
						expect (navigation.popupWasShownWithAction).notTo(beNil())
					}

					context("when the user presses the ok button") {
						beforeEach {
							fetchGames.executeWasCalled = false
							navigation.popupWasShownWithAction?()
						}

						it ("calls the fetcher again") {
							expect(fetchGames.executeWasCalled).to(beTrue())
						}
					}

				}
			}
		}

	}

	func createEventsHandler() ->
		(
		SplashNavigationNavigationMock,
		FetchGamesMock, SplashEventsHandler
	) {
			let navigation = SplashNavigationNavigationMock()
			let fetchGames = FetchGamesMock()
			let eventsHandler = SplashEventsHandler(fetchGames: fetchGames)
			eventsHandler.navigation = navigation

			return (navigation, fetchGames, eventsHandler)
	}
}

// MARK: Mocks
class SplashNavigationNavigationMock: SplashNavigation {

	var state: AppState?
	var popupWasShownWithAction: (() -> Void)?

	func presentHome(for state: AppState) {
		self.state = state
	}

	func presentInformationPopup(
		title: String?,
		message: String,
		animated: Bool,
		action: (() -> Void)?
		) {
		popupWasShownWithAction = action
	}
}

class FetchGamesMock: FetchGames {
	var executeWasCalled: Bool = false
	var gamesToReturnObserver: AnyObserver<[Game]>!
	private var _gamesToReturnObservable: Observable<[Game]>!

	init () {
		_gamesToReturnObservable = Observable.create { observer in
			self.gamesToReturnObserver = observer
			return Disposables.create ()
		}
	}

	func execute() -> Observable<[Game]> {
		executeWasCalled = true
		return _gamesToReturnObservable
	}
}

