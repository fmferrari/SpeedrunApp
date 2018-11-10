//
//  RunTests.swift
//  SpeedrunAppTests
//
//  Created by Felipe Ferrari on 10/11/2018.
//  Copyright © 2018 Felipe Ferrari. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SpeedrunApp

class RunTests: QuickSpec {
	override func spec() {
		describe("init from dictionary") {
			let runDictionary: [String: Any] = RunFactory.run().toDictionary()

			it("creates the run with the correct values") {
				let run = try! Run (fromDictionary: runDictionary)

				expect(run.id) == "abc123"
				expect(run.time) == 1
				expect(run.playerID) == "abc123"
				if let videoURL = run.videoURL {
					expect (videoURL.absoluteString)
						== "https://www.youtube.com/watch?v=-Vesbd8uJzE&feature=youtu.be"
				}
			}
		}

		describe("toDictionary") {
			let run = RunFactory.run()

			it ("returns a dictionary with the correct values") {
				let runDictionary = run.toDictionary()

				expect (runDictionary["id"] as? String) == "abc123"

				if let playersArray = try? runDictionary.valueOf("players") as [Any],
				let playerDictionary = playersArray.first as? [String: Any] {
					expect (try? playerDictionary.valueOf("id")) == "abc123"
				}

				if  let timesDictionary = try? runDictionary.valueOf("times") as [String: Any]
				{
					expect (try? timesDictionary.valueOf("realtime_t")) == 1
				}

				if  let videosDictionary = try? runDictionary.valueOf("videos") as [String: Any],
					let linksDictionary = try? videosDictionary.valueOf("links") as [Any],
					let firstLinkDictionary = linksDictionary.first as? [String:Any],
					let videoURLString = try? firstLinkDictionary.valueOf("uri") as String
				{
					expect (videoURLString) == "https://www.youtube.com/watch?v=-Vesbd8uJzE&feature=youtu.be"
				}
				
			}
		}
	}
}

