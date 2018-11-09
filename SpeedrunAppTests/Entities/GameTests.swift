//
//  GameTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SpeedrunApp

class GameTests: QuickSpec {
	override func spec() {
		describe("init from dictionary") {
			let gameDictionary: [String: Any] = GameFactory.game().toDictionary()

			it("creates the game with the correct values") {
				let game = try! Game (fromDictionary: gameDictionary)

				expect(game.id) == "abc123"
				expect(game.name) == "aName"
				expect(game.logo.absoluteString) == "https://www.speedrun.com/themes/fishy/logo.png"
			}
		}

		describe("toDictionary") {
			let game = GameFactory.game()

			it ("returns a dictionary with the correct values") {
				let gameDictionary = game.toDictionary()

				expect (gameDictionary["id"] as? String) == "abc123"
				expect (gameDictionary["abbreviation"] as? String) == "aName"

				if  let assetsDictionary = try? gameDictionary.valueOf("assets") as [String: Any],
					let logoDictionary = try? assetsDictionary.valueOf("logo") as [String: Any],
					let logoURLString = try? logoDictionary.valueOf("uri") as String
				{
					expect (logoURLString) == "https://www.speedrun.com/themes/fishy/logo.png"
				}
			}
		}
	}
}

