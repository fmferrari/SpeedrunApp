//
//  GameToDisplay.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit

struct GameToDisplay {
	let id: String
	let logo: URL
	let name: String
}

extension GameToDisplay {

	init (game: Game) {
		self.id = game.id
		self.logo = game.logo
		self.name = game.name
	}
}

extension Array where Element == Game {
	func toDisplay() -> [GameToDisplay] {
		return self.map({
			return GameToDisplay(game: $0)
		})
	}
}
