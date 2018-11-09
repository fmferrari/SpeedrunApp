//
//  FetchSpeedrunsInteractorTests.swift
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

class FetchSpeedrunsInteractorTests: QuickSpec {
	static let baseURL = "http://api.example.com"

	static let speedruns = SpeedrunFactory.speedrun()
	static let speedrunsDictionary = SpeedrunFactory.speedrun().toDictionary()
	static let getSpeedrunsResponse: [String: [[String: Any]]] =
		["data" : [ speedrunsDictionary ]]

	override func spec() {
		let fetchSpeedrunsURL
			= "\(FetchSpeedrunsInteractorTests.baseURL)/games"
		let api = SpeedrunApi (baseURL: URL(string: fetchSpeedrunsURL)!)
		let fetchSpeedruns = FetchSpeedrunsInteractor (api: api)

		context ("with an invalid response") {
			beforeEach {
				self.stub (
					contains(fetchSpeedrunsURL, method: "GET"),
					json([], status: 200)
				)
			}

			it ("throws an error of invalidResponse") {
				let blockObs = fetchSpeedruns.execute().toBlocking()
				expect { try blockObs.first() }
					.to(throwError(FetchSpeedrunsInteractorError.invalidResponse))
			}
		}

		context("with two valid speedruns and one invalid") {
			beforeEach {
				self.stub (
					contains(fetchSpeedrunsURL, method: "GET"),
					json(FetchSpeedrunsInteractorTests.getSpeedrunsResponse, status: 200)
				)
			}

			it("returns a valid citizen") {
				let blockObs = fetchSpeedruns.execute().toBlocking()
				guard
					let response = try? blockObs.first(),
					response?.count == 1
					else { fail(); return }

				expect(response?[0].id) == FetchSpeedrunsInteractorTests.speedruns.id
			}
		}
	}
}
