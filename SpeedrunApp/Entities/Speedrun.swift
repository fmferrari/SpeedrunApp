//
//  Speedrun.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

enum SpeedrunParseError: Error {
	case invalidDictionary
}

struct Speedrun {
	let id: String
}

extension Speedrun: Hashable {
	init(fromDictionary dictionary: [String : Any]) throws {
		guard let id = try? dictionary.valueOf("id") as String
			else { throw SpeedrunParseError.invalidDictionary }
		self.id = id
	}

	func toDictionary() -> [String : Any] {
		return [
			"id": id
		]
	}

	static func ==(lhs: Speedrun, rhs: Speedrun) -> Bool {
		return lhs.id == rhs.id
	}
}
