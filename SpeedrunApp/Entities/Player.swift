//
//  Player.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

enum PlayerParseError: Error {
	case invalidDictionary
}

struct Player {
	let id: String
	let name: String
}

extension Player: Hashable {
	init(fromDictionary dictionary: [String : Any]) throws {
		guard	let id = try? dictionary.valueOf("id") as String,
				let namesDictionary = try? dictionary.valueOf("names") as [String:Any],
				let name = try? namesDictionary.valueOf("international") as String
		else { throw PlayerParseError.invalidDictionary }
		self.id = id
		self.name = name
	}

	func toDictionary() -> [String : Any] {
		return [
			"id" : id,
			"names": ["international":name]
		] as [String : Any]
	}

	static func ==(lhs: Player, rhs: Player) -> Bool {
		return lhs.id == rhs.id
	}
}
