//
//  GameDetailPresenter.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import RxSwift

class GameDetailPresenter: ObserverPresenter {
	let game : Game
	let view : GameDetailView
	let fetchRuns : FetchRuns
	let fetchPlayerForRun : FetchPlayerForRun

	private let disposeBag: DisposeBag = DisposeBag ()

	init(
		game: Game,
		view: GameDetailView,
		fetchRuns : FetchRuns,
		fetchPlayerForRun : FetchPlayerForRun
	) {
		self.view = view
		self.game = game
		self.fetchRuns = fetchRuns
		self.fetchPlayerForRun = fetchPlayerForRun
	}

	override func subscribeToViewEvents() {
		view.showLoadingView()
		fetchFirstRun()
	}

	func fetchFirstRun() {
		fetchRuns
			.execute(for: game.id)
			.subscribe(
				onNext: {[weak self] runs in
					guard let run = runs.first
					else {
						self?.handleError()
						return
					}
					self?.fetchPlayerNameForRun(run)
				},
				onError: { [weak self] _ in
					self?.handleError()
				}
			).disposed(by: disposeBag)
	}

	func fetchPlayerNameForRun( _ run : Run ) {
		fetchPlayerForRun.execute(for: run.playerID)
			.subscribe(
				onNext: {[weak self] player in
					guard let game = self?.game
					else {
						self?.handleError()
						return
					}
					let gameDetailsToDisplay = GameDetailsToDisplay(game: game, run: run, player: player)
					self?.view.hideLoadingView()
					self?.view.setGameInformation(gameDetailsToDisplay)
				},
				onError: {[weak self] _ in
					self?.handleError()
				}
		).disposed(by: disposeBag)
	}

	func handleError() {
		view.hideLoadingView()
		view.showErrorView()
	}
}

