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
			let (presenter, view, fetchRuns, fetchPlayerForRun) = createPresenter()

			context("when subscribeToViewEvents is called") {
				beforeEach {
					presenter.subscribeToViewEvents()
				}

				it ("calls the fetch runs interactor") {
					guard let calledWithID = fetchRuns.executeWasCalledWithID else {
						fail(); return
					}

					expect(calledWithID) == GameFactory.game().id
				}

				context("when the server responds with a valid run") {
					beforeEach {
						fetchRuns.returnObserver.onNext([RunFactory.run()])
					}

					it("calls fetch player for run interactor") {
						expect(fetchPlayerForRun.executeWasCalledWithID) == RunFactory.run().playerID
					}

					context ("when the server responds successfully with a valid player") {
						beforeEach {
							fetchPlayerForRun.returnObserver.onNext(PlayerFactory.player())
						}

						it("sets the game information to the view") {
							expect(view.setGameInformationWasCalled).to(beTrue())
						}
					}

					context ("when the server responds with an error") {
						beforeEach {
							fetchPlayerForRun.returnObserver.onError(NSError())
						}

						it ("hides loading view" ) {
							fail()
						}

						it ("displays error view" ) {
							fail()
						}
					}
				}

				context ("when the server responds with an error") {
					beforeEach {
						fetchRuns.returnObserver.onError(NSError())
					}

					it ("hides loading view" ) {
						fail()
					}

					it ("displays error view" ) {
						fail()
					}
				}
			}
		}

	}

	func createPresenter() ->
	(
		GameDetailPresenter,
		GameDetailViewMock,
		FetchRunsMock,
		FetchPlayerForRunMock
	) {
			let view = GameDetailViewMock()
			let fetchRuns = FetchRunsMock()
			let fetchPlayerForRun = FetchPlayerForRunMock()
			let presenter = GameDetailPresenter(
				game: GameFactory.game(),
				view: view,
				fetchRuns: fetchRuns,
				fetchPlayerForRun: fetchPlayerForRun
			)

			return (presenter, view, fetchRuns, fetchPlayerForRun )
	}
}

// MARK: Mocks
class GameDetailViewMock: GameDetailView {
	var setGameInformationWasCalled = false
	func setGameInformation(_ gameDetails: GameDetailsToDisplay) {
		setGameInformationWasCalled = true
	}
}

class FetchRunsMock: FetchRuns {
	var executeWasCalledWithID : String?
	var returnObserver: AnyObserver<[Run]>!

	func execute (for gameID: String) -> Observable<[Run]> {
		executeWasCalledWithID = gameID

		return Observable.create { observer in
			self.returnObserver = observer
			return Disposables.create()
		}
	}
}

class FetchPlayerForRunMock: FetchPlayerForRun {
	var executeWasCalledWithID : String?
	var returnObserver: AnyObserver<Player>!

	func execute (for userID: String) -> Observable<Player> {
		executeWasCalledWithID = userID

		return Observable.create { observer in
			self.returnObserver = observer
			return Disposables.create()
		}
	}
}
