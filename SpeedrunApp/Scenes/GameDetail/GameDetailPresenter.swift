//
//  GameDetailPresenter.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import RxSwift

protocol GameDetailNavigation: class {
	func openURL( _ url: URL)
}

class GameDetailPresenter: ObserverPresenter {
	let game : Game
	var run: Run?
	let view : GameDetailView
	let fetchRuns : FetchRuns
	let fetchPlayerForRun : FetchPlayerForRun
	let viewEventsEmitter: GameDetailViewEventsEmitter
	weak var navigation : GameDetailNavigation?

	private let disposeBag: DisposeBag = DisposeBag ()

	init(
		game: Game,
		view: GameDetailView,
		viewEventsEmitter: GameDetailViewEventsEmitter,
		fetchRuns : FetchRuns,
		fetchPlayerForRun : FetchPlayerForRun
	) {
		self.view = view
		self.viewEventsEmitter = viewEventsEmitter
		self.game = game
		self.fetchRuns = fetchRuns
		self.fetchPlayerForRun = fetchPlayerForRun
	}

	override func subscribeToViewEvents() {
		subscribeToGoToVideoTappedObservable()
		view.showLoadingView()
		fetchFirstRun()
	}

	func subscribeToGoToVideoTappedObservable() {
		viewEventsEmitter.goToVideoTappedObservable
			.subscribe(onNext: { [weak self] _ in
				guard let videoURL = self?.run?.videoURL,
					UIApplication.shared.canOpenURL(videoURL)
					else { return }
				self?.navigation?.openURL(videoURL)
			}).disposed(by: disposeBag)
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
					self?.run = run
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

