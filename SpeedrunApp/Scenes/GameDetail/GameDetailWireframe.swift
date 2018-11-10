//
//  GameDetailWireframe.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

class GameDetailWireframe: ObservableViewWireframe<GameDetailPresenter> {
	let gameDetailPresenter : GameDetailPresenter

	required init(navigation: Navigation, game: Game ) {
		let view = GameDetailViewController()

		gameDetailPresenter = GameDetailPresenter(
			game: game,
			view: view,
			fetchRuns: FetchRunsInteractor.withDefaultApi,
			fetchPlayerForRun: FetchPlayerForRunInteractor.withDefaultApi
		)

		super.init(navigation: navigation, presenter: gameDetailPresenter)

		viewController = view
	}

	required init(navigation: Navigation) {
		fatalError("init(navigation:) has not been implemented")
	}
}
