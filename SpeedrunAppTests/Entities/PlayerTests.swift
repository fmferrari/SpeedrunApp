//
//  PlayerTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SpeedrunApp

class PlayerTests: QuickSpec {
	override func spec() {
		describe("init from dictionary") {
			let playerDictionary: [String: Any] = PlayerFactory.player().toDictionary()

			it("creates the player with the correct values") {
				let player = try! Player (fromDictionary: playerDictionary)

				expect(player.id) == "abc123"
				expect(player.name) == "aName"
			}
		}

		describe("toDictionary") {
			let player = PlayerFactory.player()

			it ("returns a dictionary with the correct values") {
				let playerDictionary = player.toDictionary()

				expect (playerDictionary["id"] as? String) == "abc123"

				if let namesDictionary = try? playerDictionary.valueOf("names") as [String: Any] {
					expect (namesDictionary["international"] as? String) == "aName"
				}
			}
		}
	}
}

