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
	let name: String
	let logo: URL
}

extension Speedrun: Hashable {
	init(fromDictionary dictionary: [String : Any]) throws {
		guard let id = try? dictionary.valueOf("id") as String,
			  let name = try? dictionary.valueOf("abbreviation") as String,
			  let assetsDictionary = try? dictionary.valueOf("assets") as [String: Any],
			  let logoDictionary = try? assetsDictionary.valueOf("logo") as [String: Any],
			  let logoURLString = try? logoDictionary.valueOf("uri") as String,
			  let logoURL = URL(string: logoURLString)
			else { throw SpeedrunParseError.invalidDictionary }
		self.id = id
		self.name = name
		self.logo = logoURL
	}

	func toDictionary() -> [String : Any] {
		return [
			"id": id,
			"abbreviation": name,
			"assets" : ["logo" : ["uri": logo.absoluteString]]
		]
	}

	static func ==(lhs: Speedrun, rhs: Speedrun) -> Bool {
		return lhs.id == rhs.id
	}
}
