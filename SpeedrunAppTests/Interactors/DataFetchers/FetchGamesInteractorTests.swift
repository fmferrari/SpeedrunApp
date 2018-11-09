//
//  FetchGamesInteractorTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 09/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

@testable import SpeedrunApp

import Foundation
import Quick
import Nimble
import Mockingjay
import RxBlocking
import Alamofire

class FetchGamesInteractorTests: QuickSpec {
	static let baseURL = "http://api.example.com"

	static let games = GameFactory.game()
	static let gamesDictionary = GameFactory.game().toDictionary()
	static let getGamesResponse: [String: [[String: Any]]] =
		["data" : [ gamesDictionary ]]

	override func spec() {
		let fetchGamesURL
			= "\(FetchGamesInteractorTests.baseURL)/games"
		let api = SpeedrunApi (baseURL: URL(string: fetchGamesURL)!)
		let fetchGames = FetchGamesInteractor (api: api)

		context ("with an invalid response") {
			beforeEach {
				self.stub (
					contains(fetchGamesURL, method: "GET"),
					json([], status: 200)
				)
			}

			it ("throws an error of invalidResponse") {
				let blockObs = fetchGames.execute().toBlocking()
				expect { try blockObs.first() }
					.to(throwError(FetchGamesInteractorError.invalidResponse))
			}
		}

		context("with two valid games and one invalid") {
			beforeEach {
				self.stub (
					contains(fetchGamesURL, method: "GET"),
					json(FetchGamesInteractorTests.getGamesResponse, status: 200)
				)
			}

			it("returns a valid game") {
				let blockObs = fetchGames.execute().toBlocking()
				guard
					let response = try? blockObs.first(),
					response?.count == 1
					else { fail(); return }

				expect(response?[0].id) == FetchGamesInteractorTests.games.id
			}
		}
	}
}
