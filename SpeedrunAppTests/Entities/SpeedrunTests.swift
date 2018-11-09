//
//  SpeedrunTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SpeedrunApp

class SpeedrunTests: QuickSpec {
	override func spec() {
		describe("init from dictionary") {
			let speedrunDictionary: [String: Any] = SpeedrunFactory.speedrun().toDictionary()

			it("creates the speedrun with the correct values") {
				let speedrun = try! Speedrun (fromDictionary: speedrunDictionary)

				expect(speedrun.id) == "abc123"
				expect(speedrun.name) == "aName"
				expect(speedrun.logo.absoluteString) == "https://www.speedrun.com/themes/fishy/logo.png"
			}
		}

		describe("toDictionary") {
			let speedrun = SpeedrunFactory.speedrun()

			it ("returns a dictionary with the correct values") {
				let speedrunDictionary = speedrun.toDictionary()

				expect (speedrunDictionary["id"] as? String) == "abc123"
				expect (speedrunDictionary["abbreviation"] as? String) == "aName"

				if  let assetsDictionary = try? speedrunDictionary.valueOf("assets") as [String: Any],
					let logoDictionary = try? assetsDictionary.valueOf("logo") as [String: Any],
					let logoURLString = try? logoDictionary.valueOf("uri") as String
				{
					expect (logoURLString) == "https://www.speedrun.com/themes/fishy/logo.png"
				}
			}
		}
	}
}

