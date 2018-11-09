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
			let (navigation, fetchSpeedruns, eventsHandler) = createEventsHandler()

			context("when the view is loaded") {
				beforeEach{ eventsHandler.viewDidLoad() }

				it ("calls the fetcher") {
					expect(fetchSpeedruns.executeWasCalled).to(beTrue())
				}

				context ("when the fetcher responds successfully") {
					beforeEach {
						fetchSpeedruns.speedrunsToReturnObserver.onNext([SpeedrunFactory.speedrun()])
					}

					it ("tells navigation to present home with an app state containing fetched speedruns") {
						expect (navigation.state?.speedrunsRepository.speedruns.first?.id) == SpeedrunFactory.speedrun().id
					}
				}

				context ("when the fetcher has an error") {
					beforeEach { fetchSpeedruns.speedrunsToReturnObserver.onError(NSError()) }

					it("shows the error popup") {
						expect (navigation.popupWasShownWithAction).notTo(beNil())
					}

					context("when the user presses the ok button") {
						beforeEach {
							fetchSpeedruns.executeWasCalled = false
							navigation.popupWasShownWithAction?()
						}

						it ("calls the fetcher again") {
							expect(fetchSpeedruns.executeWasCalled).to(beTrue())
						}
					}

				}
			}
		}

	}

	func createEventsHandler() ->
		(
		SplashNavigationNavigationMock,
		FetchSpeedrunsMock, SplashEventsHandler
		) {
			let navigation = SplashNavigationNavigationMock()
			let fetchSpeedruns = FetchSpeedrunsMock()
			let eventsHandler =
				SplashEventsHandler(fetchSpeedruns: fetchSpeedruns)
			eventsHandler.navigation = navigation

			return (navigation, fetchSpeedruns, eventsHandler)
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

class FetchSpeedrunsMock: FetchSpeedruns {
	var executeWasCalled: Bool = false
	var speedrunsToReturnObserver: AnyObserver<[Speedrun]>!
	private var _speedrunsToReturnObservable: Observable<[Speedrun]>!

	init () {
		_speedrunsToReturnObservable = Observable.create { observer in
			self.speedrunsToReturnObserver = observer
			return Disposables.create ()
		}
	}

	func execute() -> Observable<[Speedrun]> {
		executeWasCalled = true
		return _speedrunsToReturnObservable
	}
}

