//
//  SpeedrunToDisplay.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import UIKit

struct SpeedrunToDisplay {
	let id: String
}

extension SpeedrunToDisplay {

	init (speedrun: Speedrun) {
		self.id = speedrun.id
	}
}

extension Array where Element == Speedrun {
	func toDisplay() -> [SpeedrunToDisplay] {
		return self.map({
			return SpeedrunToDisplay(speedrun: $0)
		})
	}
}
