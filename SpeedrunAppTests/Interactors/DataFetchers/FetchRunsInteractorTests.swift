//
//  FetchRunsInteractorTests.swift
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

class FetchRunsInteractorTests: QuickSpec {
	static let baseURL = "http://api.example.com"

	static let runs = RunFactory.run()
	static let runsDictionary = RunFactory.run().toDictionary()
	static let getRunsResponse: [String: [[String: Any]]] =
		["data" : [ runsDictionary ]]

	override func spec() {
		let fetchRunsURL
			= "\(FetchRunsInteractorTests.baseURL)/runs"
		let api = SpeedrunApi (baseURL: URL(string: fetchRunsURL)!)
		let fetchRuns = FetchRunsInteractor (api: api)

		context ("with an invalid response") {
			beforeEach {
				self.stub (
					contains(fetchRunsURL, method: "GET"),
					json([], status: 200)
				)
			}

			it ("throws an error of invalidResponse") {
				let blockObs = fetchRuns.execute(for: "abc123").toBlocking()
				expect { try blockObs.first() }
					.to(throwError(FetchRunsInteractorError.invalidResponse))
			}
		}

		context("with two valid runs and one invalid") {
			beforeEach {
				self.stub (
					contains(fetchRunsURL, method: "GET"),
					json(FetchRunsInteractorTests.getRunsResponse, status: 200)
				)
			}

			it("returns a valid run") {
				let blockObs = fetchRuns.execute(for: "abc123").toBlocking()
				guard
					let response = try? blockObs.first(),
					response?.count == 1
				else { fail(); return }

				expect(response?[0].id) == FetchRunsInteractorTests.runs.id
			}
		}
	}
}
