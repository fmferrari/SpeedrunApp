//
//  GameFactory.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//


import Foundation

@testable import SpeedrunApp

class GameFactory {
	static func game (
		id: String = "abc123",
		name: String = "aName",
		logo: URL = URL(string: "https://www.speedrun.com/themes/fishy/logo.png")!
	) -> Game {
		return Game(
			id: id,
			name: name,
			logo: logo
		)
	}
}
