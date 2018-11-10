//
//  PlayerFactory.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

@testable import SpeedrunApp

class PlayerFactory {
	static func player (
		id: String = "abc123",
		name: String = "aName"
	) -> Player {
		return Player(
			id: id,
			name: name
		)
	}
}
