//
//  HomePresenterTests.swift
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

class HomePresenterTests: QuickSpec {

	override func spec() {

		context("when the presenter is created") {
			let (navigation, presenter, view, eventsEmitter) = createPresenter()

			it ("is created with its state") {
				expect(presenter.state).notTo(beNil())
			}

			context("when subscribeToViewEvents is called") {
				beforeEach {
					presenter.subscribeToViewEvents()
				}
				it("sets the games to the view") {
					expect(view.games).notTo(beNil())
				}
			}

			context ("when a games is selected") {
				beforeEach {
					eventsEmitter.gameSelectedObserver.onNext(GameToDisplay(game:GameFactory.game()))
				}
				it ("presents game detail") {
					expect(navigation.presentGameDetailWasCalledWithGame).notTo(beNil())
				}
			}
		}

	}

	func createPresenter() ->
		(
		HomeNavigationMock, HomePresenter, HomeViewMock, HomeEventsEmitterDouble
		) {
			let navigation = HomeNavigationMock()
			let state = AppState(gamesRepository: GamesRepository(games: [GameFactory.game()]))
			let view = HomeViewMock()
			let eventsEmitter = HomeEventsEmitterDouble()
			let presenter = HomePresenter(
				state: state,
				view: view,
				eventsEmitter: eventsEmitter
			)
			presenter.navigation = navigation

			return (navigation, presenter, view, eventsEmitter)
	}
}

// MARK: Mocks
class HomeNavigationMock: HomeNavigation {

	var presentGameDetailWasCalledWithGame : Game?
	func presentGameDetail(game: Game) {
		presentGameDetailWasCalledWithGame = game
	}
}

class HomeViewMock: HomeView {
	var games : [GameToDisplay]? = nil
	func setGames(_ games: [GameToDisplay]) {
		self.games = games
	}
}

class HomeEventsEmitterDouble: HomeViewEventsEmitter {
	var gameSelectedObservable: Observable<GameToDisplay> { return _gameSelectedObservable }
	var gameSelectedObserver : AnyObserver<GameToDisplay>!
	private var _gameSelectedObservable: Observable<GameToDisplay>!

	init () {
		_gameSelectedObservable = Observable.create() { observer in
			self.gameSelectedObserver = observer
			return Disposables.create()
		}
	}
}
