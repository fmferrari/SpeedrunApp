//
//  FetchPlayersForRunInteractorTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

@testable import SpeedrunApp

import Foundation
import Quick
import Nimble
import Mockingjay
import RxBlocking
import Alamofire

class FetchPlayerForRunInteractorTests: QuickSpec {
	static let baseURL = "http://api.example.com"

	static let player = PlayerFactory.player()
	static let playerDictionary = PlayerFactory.player().toDictionary()
	static let getPlayerResponse: [String: [String: Any]] =
		["data" : playerDictionary ]

	override func spec() {
		let fetchPlayerURL
			= "\(FetchPlayerForRunInteractorTests.baseURL)/users"
		let api = SpeedrunApi (baseURL: URL(string: fetchPlayerURL)!)
		let fetchPlayer = FetchPlayerForRunInteractor (api: api)

		context ("with an invalid response") {
			beforeEach {
				self.stub (
					contains(fetchPlayerURL, method: "GET"),
					json([], status: 200)
				)
			}

			it ("throws an error of invalidResponse") {
				let blockObs = fetchPlayer.execute(for: "abc123").toBlocking()
				expect { try blockObs.first() }
					.to(throwError(FetchPlayerForRunInteractorError.invalidResponse))
			}
		}

		context("with two valid player and one invalid") {
			beforeEach {
				self.stub (
					contains(fetchPlayerURL, method: "GET"),
					json(FetchPlayerForRunInteractorTests.getPlayerResponse, status: 200)
				)
			}

			it("returns a valid player") {
				let blockObs = fetchPlayer.execute(for: "abc123").toBlocking()
				guard
					let response = try? blockObs.first()
					else { fail(); return }

				expect(response?.id) == FetchPlayerForRunInteractorTests.player.id
			}
		}
	}
}
