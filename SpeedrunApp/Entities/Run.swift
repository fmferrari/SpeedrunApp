//
//  Run.swift
//  SpeedrunApp
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation

enum RunParseError: Error {
	case invalidDictionary
}

struct Run {
	let id: String
	let playerID: String
	let time: Int
	let videoURL: URL?
}

extension Run: Hashable {
	init(fromDictionary dictionary: [String : Any]) throws {
		guard	let id = try? dictionary.valueOf("id") as String,
				let playersArray = try? dictionary.valueOf("players") as [Any],
				let firstPlayerArray = playersArray.first as? [String:Any],
				let firstPlayerID = try? firstPlayerArray.valueOf("id") as String,
				let timesArray = try? dictionary.valueOf("times") as [String:Any],
				let time = try? timesArray.valueOf("realtime_t") as Int,
				let videosDictionary = try? dictionary.valueOf("videos") as [String: Any],
				let linksArray = try? videosDictionary.valueOf("links") as [Any],
				let firstVideoArray = linksArray.first as? [String:Any],
				let videoURLString = try? firstVideoArray.valueOf("uri") as String
		else { throw RunParseError.invalidDictionary }
		self.id = id
		self.playerID = firstPlayerID
		self.time = time
		if let videoURL = URL(string: videoURLString) {
			self.videoURL = videoURL
		} else {
			self.videoURL = nil
		}
	}

	func toDictionary() -> [String : Any] {
		var resultDictionary =  [
			"id" : id,
			"players": [["id":playerID]],
			"times": ["realtime_t":time] as [String:Any]
		] as [String : Any]

		if let videoURL = self.videoURL {
			resultDictionary["videos"] = ["links" : [["uri": videoURL.absoluteString]]]
		}
		return resultDictionary
	}

	static func ==(lhs: Run, rhs: Run) -> Bool {
		return lhs.id == rhs.id
	}
}
