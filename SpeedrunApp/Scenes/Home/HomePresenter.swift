//
//  HomePresenter.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//
import Foundation
import RxSwift

class HomePresenter: ObserverPresenter {
	weak var navigation : HomeNavigation?
	let state : AppState
	let view : HomeView
	let eventsEmitter: HomeViewEventsEmitter
	let disposeBag = DisposeBag()

	init(
		state: AppState,
		view: HomeView,
		eventsEmitter: HomeViewEventsEmitter
	) {
		self.view = view
		self.eventsEmitter = eventsEmitter
		self.state = state
	}

	override func subscribeToViewEvents() {
		subscribeToGameSelectedObservable()
		view.setGames(state.gamesRepository.games.toDisplay())
	}

	func subscribeToGameSelectedObservable() {
		eventsEmitter.gameSelectedObservable
			.subscribe( onNext: { [weak self] game in
				guard let sSelf = self,
						let game = sSelf.state.gamesRepository.games.filter({$0.id == game.id}).first
					else { return }
				self?.navigation?.presentGameDetail(game: game)
			}).disposed( by: disposeBag )
	}
}
