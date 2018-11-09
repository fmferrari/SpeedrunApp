//
//  SpeedrunFactory.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//


import Foundation

@testable import SpeedrunApp

class SpeedrunFactory {
	static func speedrun (
		id: String = "abc123"
	) -> Speedrun {
		return Speedrun(
			id: id
		)
	}
}
