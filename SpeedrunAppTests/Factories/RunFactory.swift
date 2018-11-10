//
//  RunFactory.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

@testable import SpeedrunApp

class RunFactory {
	static func run (
		id: String = "abc123",
		playerID: String = "abc123",
		time: Int = 1,
		videoURL: URL = URL(string: "https://www.youtube.com/watch?v=-Vesbd8uJzE&feature=youtu.be")!
	) -> Run {
		return Run(
			id: id,
			playerID: playerID,
			time: time,
			videoURL: videoURL
		)
	}
}

