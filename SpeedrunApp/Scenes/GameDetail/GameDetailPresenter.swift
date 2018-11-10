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

	init(
		game: Game,
		view: GameDetailView
	) {
		self.view = view
		self.game = game
	}

	override func subscribeToViewEvents() {
		let gameToDisplay = GameToDisplay(game: game)
		view.setGameInformation(gameToDisplay)
	}
}

